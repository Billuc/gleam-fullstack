import app/types/error
import app/utils/service_utils
import gleam/bool
import gleam/dynamic
import gleam/json
import gleam/result
import shared/types/routes
import wisp

pub type RouteOptions(p, b) {
  RouteOptions(path: p, body: b)
}

pub fn receive(
  req: wisp.Request,
  route: routes.Route(p, b, res),
  handler: fn(RouteOptions(p, b)) -> Result(res, error.AppError),
) -> Result(wisp.Response, Nil) {
  use <- bool.guard(req.method != route.method, Error(Nil))
  use path <- handle_path(req, route)
  use body <- handle_body(req, route)
  use <- service_utils.handle_result

  let result = handler(RouteOptions(path, body))
  result
  |> result.map(route.res_body_converter.encoder)
  |> result.map(json.to_string_builder)
}

pub fn handle_path(
  req: wisp.Request,
  route: routes.Route(p, _, _),
  callback: fn(p) -> wisp.Response,
) -> Result(wisp.Response, Nil) {
  let path_result = req |> wisp.path_segments |> route.path_converter.decoder

  case path_result {
    Ok(path) -> Ok(callback(path))
    Error(_) -> Error(Nil)
  }
}

pub fn handle_body(
  req: wisp.Request,
  route: routes.Route(_, b, _),
  callback: fn(b) -> wisp.Response,
) -> wisp.Response {
  let call_callback = fn(res) {
    case res {
      Ok(value) -> callback(value)
      Error(_) ->
        wisp.bad_request()
        |> wisp.string_body("Error while decoding body as JSON")
    }
  }
  case route.has_body {
    False -> call_callback(route.req_body_converter.decoder(dynamic.from(Nil)))
    True -> {
      use json <- wisp.require_json(req)
      json
      |> route.req_body_converter.decoder
      |> call_callback
    }
  }
}
