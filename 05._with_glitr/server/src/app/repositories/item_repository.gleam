import app/utils/sqlight_utils
import app/web
import cake/delete as d
import cake/insert as i
import cake/select as s
import cake/update as u
import cake/where as w
import gleam/list
import gleam/result
import gleam/string
import glitr_wisp/errors
import gluid
import shared/types/item

pub fn get(id: String, ctx: web.Context) -> Result(item.Item, errors.AppError) {
  s.new()
  |> s.selects([s.col("id"), s.col("name"), s.col("amount")])
  |> s.from_table("items")
  |> s.where(w.col("id") |> w.eq(w.string(id)))
  |> s.to_query
  |> sqlight_utils.exec_read_query(ctx.db_conn, item.db_decoder)
  |> result.then(fn(items) {
    items
    |> list.first
    |> result.replace_error(
      errors.DBError(string.append("Couldn't find item with id ", id)),
    )
  })
}

pub fn get_many(ctx: web.Context) -> Result(List(item.Item), errors.AppError) {
  s.new()
  |> s.selects([s.col("id"), s.col("name"), s.col("amount")])
  |> s.from_table("items")
  |> s.to_query
  |> sqlight_utils.exec_read_query(ctx.db_conn, item.db_decoder)
}

pub fn create(
  create: item.CreateItem,
  ctx: web.Context,
) -> Result(String, errors.AppError) {
  let id = gluid.guidv4()

  i.new()
  |> i.table("items")
  |> i.columns(["id", "name", "amount"])
  |> i.source_values([
    i.row([i.string(id), i.string(create.name), i.int(create.amount)]),
  ])
  |> i.to_query
  |> sqlight_utils.exec_write_query(ctx.db_conn, Ok)
  |> result.replace(id)
}

pub fn update(
  update: item.CreateItem,
  id: String,
  ctx: web.Context,
) -> Result(String, errors.AppError) {
  u.new()
  |> u.table("items")
  |> u.sets([
    "name" |> u.set_string(update.name),
    "amount" |> u.set_int(update.amount),
  ])
  |> u.where(w.col("id") |> w.eq(w.string(id)))
  |> u.to_query
  |> sqlight_utils.exec_write_query(ctx.db_conn, Ok)
  |> result.replace(id)
}

pub fn delete(id: String, ctx: web.Context) -> Result(String, errors.AppError) {
  d.new()
  |> d.table("items")
  |> d.where(w.col("id") |> w.eq(w.string(id)))
  |> d.to_query
  |> sqlight_utils.exec_write_query(ctx.db_conn, Ok)
  |> result.replace(id)
}
