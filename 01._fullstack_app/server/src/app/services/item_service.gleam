import app/repositories/item_repository
import app/types/error
import app/types/item
import app/web
import gleam/result
import gleam/string_builder
import wisp

pub fn get_items(ctx: web.Context) -> wisp.Response {
  let result =
    item_repository.get_many(ctx)
    |> result.try(fn(items) { Ok(item.to_json_list(items)) })

  case result {
    Ok(json) -> wisp.json_response(json, 200)
    Error(_) -> wisp.internal_server_error()
  }
}

pub fn get_item(ctx: web.Context, id: String) -> wisp.Response {
  let result =
    item_repository.get(id, ctx)
    |> result.try(fn(i) { Ok(item.to_json(i)) })

  case result {
    Ok(json) -> wisp.json_response(json, 200)
    Error(_) -> wisp.internal_server_error()
  }
}

pub fn create_item(ctx: web.Context, req: wisp.Request) -> wisp.Response {
  use json <- wisp.require_json(req)

  let result =
    json
    |> item.decoder_create
    |> result.replace_error(error.DecoderError("Error while decoding input"))
    |> result.try(item_repository.create(_, ctx))
    |> result.try(item_repository.get(_, ctx))
    |> result.try(fn(v) { Ok(item.to_json(v)) })

  case result {
    Ok(id) -> wisp.json_response(id, 200)
    Error(error.DecoderError(msg)) ->
      wisp.bad_request()
      |> wisp.set_body(wisp.Text(string_builder.from_string(msg)))
    Error(error.DBError(msg)) ->
      wisp.internal_server_error()
      |> wisp.set_body(wisp.Text(string_builder.from_string(msg)))
  }
}

pub fn update_item(
  ctx: web.Context,
  req: wisp.Request,
  id: String,
) -> wisp.Response {
  use json <- wisp.require_json(req)

  let result =
    json
    |> item.decoder_create
    |> result.replace_error(error.DecoderError("Error while decoding input"))
    |> result.try(item_repository.update(_, id, ctx))
    |> result.try(item_repository.get(_, ctx))
    |> result.try(fn(v) { Ok(item.to_json(v)) })

  case result {
    Ok(id) -> wisp.json_response(id, 200)
    Error(error.DecoderError(msg)) ->
      wisp.bad_request()
      |> wisp.set_body(wisp.Text(string_builder.from_string(msg)))
    Error(error.DBError(msg)) ->
      wisp.internal_server_error()
      |> wisp.set_body(wisp.Text(string_builder.from_string(msg)))
  }
}

pub fn delete_item(ctx: web.Context, id: String) -> wisp.Response {
  let result = item_repository.delete(id, ctx)

  case result {
    Ok(_) ->
      wisp.ok() |> wisp.set_body(wisp.Text(string_builder.from_string(id)))
    Error(_) -> wisp.internal_server_error()
  }
}
