import shared/routes/item_routes
import shared/types/item
import types/msg
import utils/service_utils

pub fn new_item(name: String) {
  service_utils.send_to_route(
    item_routes.create(),
    Nil,
    item.CreateItem(name, 0),
    msg.ServerCreatedItem,
  )
}

pub fn get_all_items() {
  service_utils.send_to_route(
    item_routes.get_all(),
    Nil,
    Nil,
    msg.ServerSentItems,
  )
}

pub fn update_item(id: String, update: item.CreateItem) {
  service_utils.send_to_route(
    item_routes.update(),
    id,
    update,
    msg.ServerUpdatedItem,
  )
}

pub fn delete_item(id: String) {
  service_utils.send_to_route(
    item_routes.delete(),
    id,
    Nil,
    msg.ServerDeletedItem,
  )
}
