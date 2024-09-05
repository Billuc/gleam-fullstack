import components/new_item.{new_item}
import components/shopping_list.{shopping_list}
import gleam/list
import lustre
import lustre/attribute
import lustre/effect.{type Effect}
import lustre/element.{type Element}
import lustre/element/html
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
  let effect = effect.none()

  #(model, effect)
}

// ------------------ UPDATE ---------------------

fn update(model: Model, msg: msg.Msg) -> #(Model, Effect(msg.Msg)) {
  let new_model = case msg {
    msg.ProductAdded(name) -> [#(name, 0), ..model]
    msg.QuantityChanged(name, amount) -> list.key_set(model, name, amount)
  }

  #(new_model, effect.none())
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
