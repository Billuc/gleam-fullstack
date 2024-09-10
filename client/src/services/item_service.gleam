import gleam/json
import gleam/string
import lustre_http
import types/model
import types/msg

pub fn new_item(name: String) {
  let url = "http://localhost:2345/items"
  lustre_http.post(
    url,
    json.object([#("name", json.string(name)), #("amount", json.int(0))]),
    lustre_http.expect_json(model.item_decoder, msg.ServerCreatedItem),
  )
}

pub fn get_all_items() {
  let url = "http://localhost:2345/items"
  lustre_http.get(
    url,
    lustre_http.expect_json(model.item_list_decoder, msg.ServerSentItems),
  )
}

pub fn update_item(id: String, update: model.UpsertItem) {
  let url = string.append("http://localhost:2345/items/", id)
  lustre_http.post(
    url,
    json.object([
      #("name", json.string(update.name)),
      #("amount", json.int(update.amount)),
    ]),
    lustre_http.expect_json(model.item_decoder, msg.ServerUpdatedItem),
  )
}
