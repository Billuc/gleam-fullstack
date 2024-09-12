import gleam/int
import gleam/result
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import lustre/event
import shared/types/item
import types/msg

pub fn shopping_item(item: item.Item) -> Element(msg.Msg) {
  let handle_amount_input = fn(e) {
    event.value(e)
    |> result.nil_error
    |> result.then(int.parse)
    |> result.map(fn(v) {
      msg.QuantityChanged(item.id, item.CreateItem(item.name, v))
    })
    |> result.replace_error([])
  }

  let handle_remove_input = fn(_) { Ok(msg.ProductRemoved(item.id)) }

  html.div([], [
    html.label(
      [
        attribute.class(
          "flex justify-between gap-4 pb-1 border-b border-neutral-900",
        ),
      ],
      [
        html.text(item.name),
        html.input([
          attribute.type_("number"),
          attribute.value(int.to_string(item.amount)),
          attribute.class("w-1/3 pl-2 rounded-sm bg-white/50 hover:bg-white/75"),
          event.on("input", handle_amount_input),
        ]),
        html.button(
          [
            attribute.class(
              "w-6 h-6 flex justify-center rounded-full bg-red-500 hover:bg-red-600 text-white font-bold",
            ),
            event.on("click", handle_remove_input),
          ],
          [html.text("x")],
        ),
      ],
    ),
  ])
}
