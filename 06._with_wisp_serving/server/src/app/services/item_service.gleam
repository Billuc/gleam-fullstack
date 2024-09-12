import app/repositories/item_repository
import app/web
import gleam/result
import glitr_wisp
import glitr_wisp/errors
import shared/types/item

pub fn get_all(
  ctx: web.Context,
  _opts: glitr_wisp.RouteOptions(Nil, Nil),
) -> Result(List(item.Item), errors.AppError) {
  item_repository.get_many(ctx)
}

pub fn get(
  ctx: web.Context,
  opts: glitr_wisp.RouteOptions(String, Nil),
) -> Result(item.Item, errors.AppError) {
  item_repository.get(opts.path, ctx)
}

pub fn create(
  ctx: web.Context,
  opts: glitr_wisp.RouteOptions(Nil, item.CreateItem),
) -> Result(item.Item, errors.AppError) {
  opts.body
  |> item_repository.create(ctx)
  |> result.try(item_repository.get(_, ctx))
}

pub fn update(
  ctx: web.Context,
  opts: glitr_wisp.RouteOptions(String, item.CreateItem),
) -> Result(item.Item, errors.AppError) {
  opts.body
  |> item_repository.update(opts.path, ctx)
  |> result.try(item_repository.get(_, ctx))
}

pub fn delete(
  ctx: web.Context,
  opts: glitr_wisp.RouteOptions(String, Nil),
) -> Result(String, errors.AppError) {
  item_repository.delete(opts.path, ctx)
}
