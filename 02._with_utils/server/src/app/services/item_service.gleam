import app/repositories/item_repository
import app/types/item
import app/utils/service_utils
import app/web
import gleam/result
import gleam/string_builder
import wisp

pub fn get_items(ctx: web.Context) -> wisp.Response {
  use <- service_utils.handle_result

  item_repository.get_many(ctx)
  |> result.try(fn(items) { Ok(item.to_json_list(items)) })
}

pub fn get_item(ctx: web.Context, id: String) -> wisp.Response {
  use <- service_utils.handle_result

  item_repository.get(id, ctx)
  |> result.try(fn(i) { Ok(item.to_json(i)) })
}

pub fn create_item(ctx: web.Context, req: wisp.Request) -> wisp.Response {
  use #(_, json) <- service_utils.with_route_params(
    req,
    fn(_) { Ok(Nil) },
    item.decoder_create,
  )
  use <- service_utils.handle_result

  json
  |> item_repository.create(ctx)
  |> result.try(item_repository.get(_, ctx))
  |> result.try(fn(v) { Ok(item.to_json(v)) })
}

pub fn update_item(
  ctx: web.Context,
  req: wisp.Request,
  id: String,
) -> wisp.Response {
  use #(_, json) <- service_utils.with_route_params(
    req,
    fn(_) { Ok(Nil) },
    item.decoder_create,
  )
  use <- service_utils.handle_result

  json
  |> item_repository.update(id, ctx)
  |> result.try(item_repository.get(_, ctx))
  |> result.try(fn(v) { Ok(item.to_json(v)) })
}

pub fn delete_item(ctx: web.Context, id: String) -> wisp.Response {
  use <- service_utils.handle_result

  item_repository.delete(id, ctx) |> result.map(string_builder.from_string)
}
