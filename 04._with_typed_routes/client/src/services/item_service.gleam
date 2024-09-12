import gleam/http
import gleam/http/request
import gleam/json
import gleam/string
import lustre_http
import shared/types/item
import types/msg

pub fn new_item(name: String) {
  let url = "http://localhost:2345/items"
  lustre_http.post(
    url,
    json.object([#("name", json.string(name)), #("amount", json.int(0))]),
    lustre_http.expect_json(item.json_decoder, msg.ServerCreatedItem),
  )
}

pub fn get_all_items() {
  let url = "http://localhost:2345/items"
  lustre_http.get(
    url,
    lustre_http.expect_json(item.json_list_decoder, msg.ServerSentItems),
  )
}

pub fn update_item(id: String, update: item.CreateItem) {
  let url = string.append("http://localhost:2345/items/", id)
  lustre_http.post(
    url,
    json.object([
      #("name", json.string(update.name)),
      #("amount", json.int(update.amount)),
    ]),
    lustre_http.expect_json(item.json_decoder, msg.ServerUpdatedItem),
  )
}

pub fn delete_item(id: String) {
  let url = string.append("http://localhost:2345/items/", id)
  let assert Ok(req) = request.to(url)

  lustre_http.send(
    req |> request.set_method(http.Delete),
    lustre_http.expect_text(msg.ServerDeletedItem),
  )
}
