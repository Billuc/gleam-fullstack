import app/services/item_service
import app/web
import gleam/http
import gleam/string_builder
import wisp.{type Request, type Response}

type RouteSignature {
  RouteSignature(method: http.Method, segments: List(String))
}

pub fn handle_request(req: Request, ctx: web.Context) -> Response {
  use _req <- web.middleware(req)
  let sig = RouteSignature(req.method, wisp.path_segments(req))

  case sig {
    RouteSignature(http.Get, ["items"]) -> item_service.get_items(ctx)
    RouteSignature(http.Post, ["items"]) -> item_service.create_item(ctx, req)
    _ -> wisp.not_found()
  }
}
