import gleam/int
import gleam/result
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import lustre/event
import types/msg

pub fn shopping_item(name: String, amount: Int) -> Element(msg.Msg) {
  let handle_amount_input = fn(e) {
    event.value(e)
    |> result.nil_error
    |> result.then(int.parse)
    |> result.map(msg.QuantityChanged(name, _))
    |> result.replace_error([])
  }

  html.div([], [
    html.label(
      [
        attribute.class(
          "flex justify-between gap-4 pb-1 border-b border-neutral-900",
        ),
      ],
      [
        html.text(name),
        html.input([
          attribute.type_("number"),
          attribute.value(int.to_string(amount)),
          attribute.class("w-1/3 pl-2 rounded-sm bg-white/50 hover:bg-white/75"),
          event.on("input", handle_amount_input),
        ]),
      ],
    ),
  ])
}
