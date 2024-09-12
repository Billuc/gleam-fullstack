import gleam/dynamic
import gleam/http
import gleam/json
import shared/types/converter
import shared/types/item
import shared/types/routes
import shared/utils/converters

pub fn get_all() -> routes.Route(Nil, Nil, List(item.Item)) {
  routes.Route(
    http.Get,
    http.Http,
    "localhost",
    2345,
    False,
    converters.simple_path_converter(["items"]),
    converters.no_body_converter(),
    item.item_list_converter,
  )
}

pub fn get() -> routes.Route(String, Nil, item.Item) {
  routes.Route(
    http.Get,
    http.Http,
    "localhost",
    2345,
    False,
    converters.id_path_converter(["items"]),
    converters.no_body_converter(),
    item.item_converter,
  )
}

pub fn create() -> routes.Route(Nil, item.CreateItem, item.Item) {
  routes.Route(
    http.Post,
    http.Http,
    "localhost",
    2345,
    True,
    converters.simple_path_converter(["items"]),
    item.item_create_converter,
    item.item_converter,
  )
}

pub fn update() -> routes.Route(String, item.CreateItem, item.Item) {
  routes.Route(
    http.Post,
    http.Http,
    "localhost",
    2345,
    True,
    converters.id_path_converter(["items"]),
    item.item_create_converter,
    item.item_converter,
  )
}

pub fn delete() -> routes.Route(String, Nil, String) {
  routes.Route(
    http.Delete,
    http.Http,
    "localhost",
    2345,
    False,
    converters.id_path_converter(["items"]),
    converters.no_body_converter(),
    converter.JsonConverter(json.string, dynamic.string),
  )
}
