import client/components/new_item.{new_item}
import client/components/shopping_list.{shopping_list}
import client/services/item_service
import client/types/model.{type Model}
import client/types/msg
import gleam/list
import lustre
import lustre/attribute
import lustre/effect.{type Effect}
import lustre/element.{type Element}
import lustre/element/html

// ------------------ MAIN -------------------

pub fn main() {
  let app = lustre.application(init, update, view)
  let assert Ok(_) = lustre.start(app, "#app", Nil)

  Nil
}

// ----------------- INIT --------------------

fn init(_) -> #(Model, Effect(msg.Msg)) {
  let model = []
  let effect = item_service.get_all_items()

  #(model, effect)
}

// ------------------ UPDATE ---------------------

fn update(model: Model, msg: msg.Msg) -> #(Model, Effect(msg.Msg)) {
  case msg {
    msg.ProductAdded(name) -> #(model, item_service.new_item(name))
    msg.QuantityChanged(id, update) -> #(
      model,
      item_service.update_item(id, update),
    )
    msg.ProductRemoved(id) -> #(model, item_service.delete_item(id))
    msg.ServerCreatedItem(Ok(item)) -> #(model |> add_item(item), effect.none())
    msg.ServerCreatedItem(Error(_)) -> #(model, effect.none())
    msg.ServerSentItems(Ok(items)) -> #(gen_model(items), effect.none())
    msg.ServerSentItems(Error(_)) -> #(model, effect.none())
    msg.ServerUpdatedItem(Ok(item)) -> #(
      model |> update_item(item),
      effect.none(),
    )
    msg.ServerUpdatedItem(Error(_)) -> #(model, effect.none())
    msg.ServerDeletedItem(Ok(id)) -> #(model |> delete_item(id), effect.none())
    msg.ServerDeletedItem(Error(_)) -> #(model, effect.none())
  }
}

fn add_item(model: Model, item: model.ShoppingItem) -> Model {
  [#(item.id, item), ..model]
}

fn gen_model(items: List(model.ShoppingItem)) -> Model {
  items |> list.map(fn(i) { #(i.id, i) })
}

fn update_item(model: Model, item: model.ShoppingItem) -> Model {
  model |> list.key_set(item.id, item)
}

fn delete_item(model: Model, id: String) -> Model {
  let res = model |> list.key_pop(id)

  case res {
    Ok(#(_poped, rest)) -> rest
    Error(_) -> model
  }
}

// ------------------------ VIEW -------------------------

fn view(model: Model) -> Element(msg.Msg) {
  html.div(
    [attribute.class("mx-auto p-4 bg-yellow-200 w-fit mt-16 rounded-md")],
    [
      html.h1([attribute.class("text-xl font-bold text-center mb-4")], [
        html.text("My shopping list"),
      ]),
      shopping_list(model),
      new_item(),
    ],
  )
}
