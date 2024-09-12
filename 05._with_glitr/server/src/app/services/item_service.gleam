import app/repositories/item_repository
import app/types/error
import app/utils/route_utils
import app/web
import gleam/result
import shared/types/item

pub fn get_all(
  ctx: web.Context,
  _opts: route_utils.RouteOptions(Nil, Nil),
) -> Result(List(item.Item), error.AppError) {
  item_repository.get_many(ctx)
}

pub fn get(
  ctx: web.Context,
  opts: route_utils.RouteOptions(String, Nil),
) -> Result(item.Item, error.AppError) {
  item_repository.get(opts.path, ctx)
}

pub fn create(
  ctx: web.Context,
  opts: route_utils.RouteOptions(Nil, item.CreateItem),
) -> Result(item.Item, error.AppError) {
  opts.body
  |> item_repository.create(ctx)
  |> result.try(item_repository.get(_, ctx))
}

pub fn update(
  ctx: web.Context,
  opts: route_utils.RouteOptions(String, item.CreateItem),
) -> Result(item.Item, error.AppError) {
  opts.body
  |> item_repository.update(opts.path, ctx)
  |> result.try(item_repository.get(_, ctx))
}

pub fn delete(
  ctx: web.Context,
  opts: route_utils.RouteOptions(String, Nil),
) -> Result(String, error.AppError) {
  item_repository.delete(opts.path, ctx)
}
