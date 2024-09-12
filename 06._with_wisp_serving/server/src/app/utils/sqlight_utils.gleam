import cake
import cake/dialect/sqlite_dialect
import cake/param
import gleam/dynamic.{type Dynamic}
import gleam/list
import gleam/result
import gleam/string
import glitr_wisp/errors
import pprint
import sqlight

pub fn exec_read_query(
  read_query: cake.ReadQuery,
  connection: sqlight.Connection,
  decoder: fn(Dynamic) -> Result(a, List(dynamic.DecodeError)),
) -> Result(List(a), errors.AppError) {
  let query =
    read_query
    |> sqlite_dialect.read_query_to_prepared_statement

  pprint.debug(query |> cake.get_sql)
  pprint.debug(query |> cake.get_params)

  sqlight.query(
    query |> cake.get_sql,
    connection,
    query |> cake.get_params |> list.map(map_param),
    decoder,
  )
  |> result.map_error(fn(err) {
    errors.DBError(string.append("Error during query : ", err.message))
  })
}

pub fn exec_write_query(
  write_query: cake.WriteQuery(_),
  connection: sqlight.Connection,
  decoder: fn(Dynamic) -> Result(a, List(dynamic.DecodeError)),
) -> Result(List(a), errors.AppError) {
  let query =
    write_query
    |> sqlite_dialect.write_query_to_prepared_statement

  pprint.debug(query |> cake.get_sql)
  pprint.debug(query |> cake.get_params)

  sqlight.query(
    query |> cake.get_sql,
    connection,
    query |> cake.get_params |> list.map(map_param),
    decoder,
  )
  |> result.map_error(fn(err) {
    errors.DBError(string.append("Error during query : ", err.message))
  })
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
