import gleam/dynamic

pub type Model =
  List(#(String, ShoppingItem))

pub type ShoppingItem {
  ShoppingItem(id: String, name: String, amount: Int)
}

pub type UpsertItem {
  UpsertItem(name: String, amount: Int)
}

pub fn item_decoder(
  value: dynamic.Dynamic,
) -> Result(ShoppingItem, List(dynamic.DecodeError)) {
  value
  |> dynamic.decode3(
    ShoppingItem,
    dynamic.field("id", dynamic.string),
    dynamic.field("name", dynamic.string),
    dynamic.field("amount", dynamic.int),
  )
}

pub fn item_list_decoder(
  value: dynamic.Dynamic,
) -> Result(List(ShoppingItem), List(dynamic.DecodeError)) {
  value
  |> dynamic.list(item_decoder)
}
