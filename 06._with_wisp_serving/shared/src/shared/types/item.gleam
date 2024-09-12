import gleam/dynamic
import gleam/json
import gleam/result
import glitr

pub type Item {
  Item(id: String, name: String, amount: Int)
}

pub type CreateItem {
  CreateItem(name: String, amount: Int)
}

pub const item_converter = glitr.JsonConverter(item_encoder, item_decoder)

pub const item_list_converter = glitr.JsonConverter(
  item_list_encoder,
  item_list_decoder,
)

pub const item_create_converter = glitr.JsonConverter(
  encoder_create,
  decoder_create,
)

fn item_encoder(item: Item) -> json.Json {
  json.object([
    #("id", json.string(item.id)),
    #("name", json.string(item.name)),
    #("amount", json.int(item.amount)),
  ])
}

fn item_decoder(
  value: dynamic.Dynamic,
) -> Result(Item, List(dynamic.DecodeError)) {
  value
  |> dynamic.decode3(
    Item,
    dynamic.field("id", dynamic.string),
    dynamic.field("name", dynamic.string),
    dynamic.field("amount", dynamic.int),
  )
}

fn item_list_encoder(items: List(Item)) -> json.Json {
  json.array(items, item_encoder)
}

fn item_list_decoder(
  value: dynamic.Dynamic,
) -> Result(List(Item), List(dynamic.DecodeError)) {
  value
  |> dynamic.list(item_decoder)
}

pub fn encoder_create(value: CreateItem) -> json.Json {
  json.object([
    #("name", json.string(value.name)),
    #("amount", json.int(value.amount)),
  ])
}

pub fn decoder_create(
  value: dynamic.Dynamic,
) -> Result(CreateItem, List(dynamic.DecodeError)) {
  value
  |> dynamic.decode2(
    CreateItem,
    dynamic.field("name", dynamic.string),
    dynamic.field("amount", dynamic.int),
  )
}

pub fn db_decoder(
  value: dynamic.Dynamic,
) -> Result(Item, List(dynamic.DecodeError)) {
  value
  |> dynamic.tuple3(dynamic.string, dynamic.string, dynamic.int)
  |> result.try(fn(v) { Ok(Item(v.0, v.1, v.2)) })
}
