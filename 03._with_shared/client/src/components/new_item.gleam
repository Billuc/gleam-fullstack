import decipher
import gleam/dynamic
import gleam/result
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import lustre/event
import types/msg

pub fn new_item() -> Element(msg.Msg) {
  let handle_click = fn(e) {
    let path = ["target", "previousElementSibling", "value"]

    e
    |> decipher.at(path, dynamic.string)
    |> result.map(msg.ProductAdded)
  }

  html.div([attribute.class("bg-neutral-800 p-2 rounded-md w-fit mx-auto")], [
    html.input([
      attribute.class(
        "bg-neutral-700 hover:bg-neutral-600 rounded-sm text-neutral-100",
      ),
    ]),
    html.button(
      [
        attribute.class(
          "ml-2 text-neutral-100 font-bold hover:bg-neutral-700 px-1",
        ),
        event.on("click", handle_click),
      ],
      [html.text("New")],
    ),
  ])
}
