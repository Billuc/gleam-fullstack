import app/services/item_service
import app/utils/router
import app/web
import shared/routes/item_routes
import wisp.{type Request, type Response}

pub fn handle_request(req: Request, ctx: web.Context) -> Response {
  use _req <- web.middleware(req)

  router.for(req)
  |> router.try(item_routes.get_all(), item_service.get_all(ctx, _))
  |> router.try(item_routes.get(), item_service.get(ctx, _))
  |> router.try(item_routes.create(), item_service.create(ctx, _))
  |> router.try(item_routes.update(), item_service.update(ctx, _))
  |> router.try(item_routes.delete(), item_service.delete(ctx, _))
  |> router.unwrap
}
