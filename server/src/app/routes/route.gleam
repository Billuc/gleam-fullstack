import gleam/bool
import gleam/list
import gleam/result
import gleam/string
import wisp

pub type RouteParams(params_type, query_type, body_type) {
  RouteParams(params: params_type, query: query_type, body: body_type)
}

pub type Route(params_type, query_type, body_type, route_result) {
  Route(
    match: List(String),
    handler: fn(RouteParams(params_type, query_type, body_type)) -> route_result,
  )
}

pub fn register_route(
  req: wisp.Request,
  route: Route(params_type, query_type, body_type, route_result),
) -> wisp.Response {
  let segments = wisp.path_segments(req)
  let params_from_path = extract_params_from_path(segments, route.match, [])

  use <- bool.guard(result.is_error(params_from_path), wisp.not_found())
  let assert Ok(params) = params_from_path

  wisp.not_found()
}

fn extract_params_from_path(
  path_segments: List(String),
  route_segments: List(String),
  params: List(#(String, String)),
) -> Result(List(#(String, String)), Nil) {
  use <- bool.guard(
    bool.and(list.is_empty(path_segments), list.is_empty(route_segments)),
    Ok(params),
  )
  use <- bool.guard(
    bool.or(list.is_empty(path_segments), list.is_empty(route_segments)),
    Error(Nil),
  )

  let assert [first_path, ..rest_path] = path_segments
  let assert [first_route, ..rest_route] = route_segments

  let new_params = compare_segments(first_path, first_route, params)

  case new_params {
    Ok(p) -> extract_params_from_path(rest_path, rest_route, p)
    Error(_) -> Error(Nil)
  }
}

fn compare_segments(
  from_path: String,
  from_route: String,
  params: List(#(String, String)),
) -> Result(List(#(String, String)), Nil) {
  use <- bool.guard(from_path == from_route, Ok(params))
  use <- bool.guard(!string.starts_with(from_route, ":"), Error(Nil))

  let new_params = [#(string.drop_left(from_route, 1), from_path), ..params]
  Ok(new_params)
}
