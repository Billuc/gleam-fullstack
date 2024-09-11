import app/types/error
import gleam/dynamic.{type Dynamic}
import gleam/http/request
import gleam/result
import gleam/string_builder
import wisp

pub fn handle_result(
  handler: fn() -> Result(string_builder.StringBuilder, error.AppError),
) -> wisp.Response {
  let result = handler()

  case result {
    Ok(res) -> wisp.json_response(res, 200)
    Error(error.DecoderError(msg)) ->
      wisp.json_response(string_builder.from_string(msg), 400)
    Error(error.DBError(msg)) ->
      wisp.json_response(string_builder.from_string(msg), 500)
  }
}

pub fn with_route_params(
  req: wisp.Request,
  query_decoder: fn(List(#(String, String))) ->
    Result(a, List(dynamic.DecodeError)),
  body_decoder: fn(Dynamic) -> Result(b, List(dynamic.DecodeError)),
  handler: fn(#(a, b)) -> wisp.Response,
) -> wisp.Response {
  use query <- with_query(req, query_decoder)
  use body <- with_body(req, body_decoder)

  handler(#(query, body))
}

fn with_body(
  req: wisp.Request,
  body_decoder: fn(Dynamic) -> Result(a, List(dynamic.DecodeError)),
  handler: fn(a) -> wisp.Response,
) -> wisp.Response {
  use json <- wisp.require_json(req)
  let body = json |> body_decoder

  case body {
    Ok(value) -> handler(value)
    Error(_) ->
      wisp.bad_request()
      |> wisp.string_body("Error while decoding body as JSON")
  }
}

fn with_query(
  req: wisp.Request,
  query_decoder: fn(List(#(String, String))) ->
    Result(a, List(dynamic.DecodeError)),
  handler: fn(a) -> wisp.Response,
) -> wisp.Response {
  let query =
    request.get_query(req)
    |> result.replace_error([])
    |> result.try(query_decoder)

  case query {
    Ok(value) -> handler(value)
    Error(_) ->
      wisp.bad_request() |> wisp.string_body("Error while decoding query")
  }
}
