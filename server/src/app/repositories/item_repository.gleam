import app/types/error
import app/types/item
import app/web
import gleam/dynamic
import gleam/list
import gleam/result
import gleam/string
import gluid
import sqlight

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
