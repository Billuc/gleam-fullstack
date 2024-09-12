import app/services/item_service
import app/web
import glitr_wisp
import shared/routes/item_routes
import wisp.{type Request, type Response}

pub fn handle_request(req: Request, ctx: web.Context) -> Response {
  use _req <- web.middleware(req)

  glitr_wisp.for(req)
  |> glitr_wisp.try(item_routes.get_all(), item_service.get_all(ctx, _))
  |> glitr_wisp.try(item_routes.get(), item_service.get(ctx, _))
  |> glitr_wisp.try(item_routes.create(), item_service.create(ctx, _))
  |> glitr_wisp.try(item_routes.update(), item_service.update(ctx, _))
  |> glitr_wisp.try(item_routes.delete(), item_service.delete(ctx, _))
  |> glitr_wisp.unwrap
}
