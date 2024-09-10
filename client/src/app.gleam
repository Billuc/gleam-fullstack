import components/new_item.{new_item}
import components/shopping_list.{shopping_list}
import gleam/list
import lustre
import lustre/attribute
import lustre/effect.{type Effect}
import lustre/element.{type Element}
import lustre/element/html
import services/item_service
import types/model.{type Model}
import types/msg

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
    msg.ServerCreatedItem(Ok(item)) -> #(
      [#(item.id, item), ..model],
      effect.none(),
    )
    msg.ServerCreatedItem(Error(_)) -> #(model, effect.none())
    msg.ServerSentItems(Ok(items)) -> #(
      items |> list.map(fn(i) { #(i.id, i) }),
      effect.none(),
    )
    msg.ServerSentItems(Error(_)) -> #(model, effect.none())
    msg.ServerUpdatedItem(Ok(item)) -> #(
      model |> list.key_set(item.id, item),
      effect.none(),
    )
    msg.ServerUpdatedItem(Error(_)) -> #(model, effect.none())
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
