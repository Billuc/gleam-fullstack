import lustre/effect
import lustre_http
import shared/types/routes

pub fn send_to_route(
  route: routes.Route(p, req_b, res_b),
  path: p,
  body: req_b,
  as_msg: fn(Result(res_b, lustre_http.HttpError)) -> msg,
) -> effect.Effect(msg) {
  lustre_http.send(
    route |> routes.request(path, body),
    lustre_http.expect_json(route.res_body_converter.decoder, as_msg),
  )
}
