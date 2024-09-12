import gleam/http
import gleam/http/request
import gleam/json
import gleam/string
import shared/types/converter

pub type Route(path_type, req_body_type, res_body_type) {
  Route(
    method: http.Method,
    scheme: http.Scheme,
    host: String,
    port: Int,
    has_body: Bool,
    path_converter: converter.PathConverter(path_type),
    req_body_converter: converter.JsonConverter(req_body_type),
    res_body_converter: converter.JsonConverter(res_body_type),
  )
}

pub fn request(
  route: Route(p, rqb, rsb),
  path: p,
  body: rqb,
) -> request.Request(String) {
  let req =
    request.new()
    |> request.set_method(route.method)
    |> request.set_scheme(route.scheme)
    |> request.set_host(route.host)
    |> request.set_port(route.port)
    |> request.set_path(
      path |> route.path_converter.encoder |> string.join("/"),
    )

  case route.has_body {
    True ->
      req
      |> request.set_body(
        body |> route.req_body_converter.encoder |> json.to_string,
      )
      |> request.set_header("Content-Type", "application/json")
    False -> req
  }
}
