import client/components/shopping_item.{shopping_item}
import client/types/model
import client/types/msg
import gleam/list
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html

pub fn shopping_list(model: model.Model) -> Element(msg.Msg) {
  element.keyed(html.div([attribute.class("flex flex-col gap-2 pb-2")], _), {
    use #(id, item) <- list.map(model)
    let component = shopping_item(item)

    #(id, component)
  })
}
