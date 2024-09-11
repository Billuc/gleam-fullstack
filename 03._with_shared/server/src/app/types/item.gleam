import gleam/dynamic
import gleam/json
import gleam/result
import gleam/string_builder.{type StringBuilder}

pub type Item {
  Item(id: String, name: String, amount: Int)
}

pub type CreateItem {
  CreateItem(name: String, amount: Int)
}

pub fn decoder(
  value: dynamic.Dynamic,
) -> Result(Item, List(dynamic.DecodeError)) {
  value
  |> dynamic.tuple3(dynamic.string, dynamic.string, dynamic.int)
  |> result.try(fn(v) { Ok(Item(v.0, v.1, v.2)) })
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

fn to_json_object(item: Item) -> json.Json {
  json.object([
    #("id", json.string(item.id)),
    #("name", json.string(item.name)),
    #("amount", json.int(item.amount)),
  ])
}

pub fn to_json(item: Item) -> StringBuilder {
  item
  |> to_json_object
  |> json.to_string_builder
}

pub fn to_json_list(items: List(Item)) -> StringBuilder {
  items
  |> json.array(to_json_object)
  |> json.to_string_builder
}
