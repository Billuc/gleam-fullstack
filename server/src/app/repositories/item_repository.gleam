import app/types/error
import app/types/item
import app/web
import cake
import cake/delete as d
import cake/dialect/sqlite_dialect
import cake/param
import cake/update as u
import cake/where as w
import gleam/dynamic
import gleam/list
import gleam/result
import gleam/string
import gluid
import pprint
import sqlight

pub fn get(id: String, ctx: web.Context) -> Result(item.Item, error.AppError) {
  let sql =
    "
    select id, name, amount
    from items
    where id = ?;
    "

  let results =
    sqlight.query(sql, ctx.db_conn, [sqlight.text(id)], item.decoder)

  case results {
    Ok(res) ->
      res
      |> list.first
      |> result.replace_error(
        error.DBError(string.append("Couldn't find item with id ", id)),
      )
    Error(err) ->
      Error(error.DBError(string.append("Error during query : ", err.message)))
  }
}

pub fn get_many(ctx: web.Context) -> Result(List(item.Item), error.AppError) {
  let sql =
    "
    select id, name, amount
    from items;
    "

  let results = sqlight.query(sql, ctx.db_conn, [], item.decoder)

  case results {
    Ok(res) -> Ok(res)
    Error(err) ->
      Error(error.DBError(string.append("Error during query : ", err.message)))
  }
}

pub fn create(
  create: item.CreateItem,
  ctx: web.Context,
) -> Result(String, error.AppError) {
  let sql =
    "
    insert into items(id, name, amount) values (?, ?, ?) returning [id];
  "

  let results =
    sqlight.query(
      sql,
      ctx.db_conn,
      [
        sqlight.text(gluid.guidv4()),
        sqlight.text(create.name),
        sqlight.int(create.amount),
      ],
      dynamic.element(0, dynamic.string),
    )

  case results {
    Ok(ids) ->
      ids
      |> list.first
      |> result.replace_error(error.DBError("No results"))
    Error(err) ->
      Error(error.DBError(string.append("Error during query : ", err.message)))
  }
}

pub fn update(
  update: item.CreateItem,
  id: String,
  ctx: web.Context,
) -> Result(String, error.AppError) {
  let query =
    u.new()
    |> u.table("items")
    |> u.sets([
      "name" |> u.set_string(update.name),
      "amount" |> u.set_int(update.amount),
    ])
    |> u.where(w.col("id") |> w.eq(w.string(id)))
    |> u.to_query
    |> sqlite_dialect.write_query_to_prepared_statement

  pprint.debug(query |> cake.get_sql)
  pprint.debug(query |> cake.get_params)

  let results =
    sqlight.query(
      query |> cake.get_sql,
      ctx.db_conn,
      query |> cake.get_params |> list.map(map_param),
      fn(_) { Ok(Nil) },
    )

  case results {
    Ok(_) -> Ok(id)
    Error(err) ->
      Error(error.DBError(string.append("Error during query : ", err.message)))
  }
}

pub fn delete(id: String, ctx: web.Context) -> Result(Nil, error.AppError) {
  let query =
    d.new()
    |> d.table("items")
    |> d.where(w.col("id") |> w.eq(w.string(id)))
    |> d.to_query
    |> sqlite_dialect.write_query_to_prepared_statement

  pprint.debug(query |> cake.get_sql)
  pprint.debug(query |> cake.get_params)

  let results =
    sqlight.query(
      query |> cake.get_sql,
      ctx.db_conn,
      query |> cake.get_params |> list.map(map_param),
      fn(_) { Ok(Nil) },
    )

  case results {
    Ok(_) -> Ok(Nil)
    Error(err) ->
      Error(error.DBError(string.append("Error during query : ", err.message)))
  }
}

fn map_param(p: param.Param) -> sqlight.Value {
  case p {
    param.BoolParam(v) -> sqlight.bool(v)
    param.FloatParam(v) -> sqlight.float(v)
    param.IntParam(v) -> sqlight.int(v)
    param.StringParam(v) -> sqlight.text(v)
    param.NullParam -> sqlight.null()
  }
}
