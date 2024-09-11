import gleam/http
import server/services/item_service
import server/web
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
    RouteSignature(http.Get, ["items", id]) -> item_service.get_item(ctx, id)
    RouteSignature(http.Post, ["items", id]) ->
      item_service.update_item(ctx, req, id)
    RouteSignature(http.Delete, ["items", id]) ->
      item_service.delete_item(ctx, id)
    _ -> wisp.not_found()
  }
}
