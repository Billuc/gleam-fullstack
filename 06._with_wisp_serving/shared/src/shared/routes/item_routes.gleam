import gleam/dynamic
import gleam/http
import gleam/json
import glitr
import glitr/utils
import shared/types/item

pub fn get_all() -> glitr.Route(Nil, Nil, List(item.Item)) {
  glitr.Route(
    http.Get,
    http.Http,
    "localhost",
    2345,
    False,
    utils.simple_path_converter(["items"]),
    utils.no_body_converter(),
    item.item_list_converter,
  )
}

pub fn get() -> glitr.Route(String, Nil, item.Item) {
  glitr.Route(
    http.Get,
    http.Http,
    "localhost",
    2345,
    False,
    utils.id_path_converter(["items"]),
    utils.no_body_converter(),
    item.item_converter,
  )
}

pub fn create() -> glitr.Route(Nil, item.CreateItem, item.Item) {
  glitr.Route(
    http.Post,
    http.Http,
    "localhost",
    2345,
    True,
    utils.simple_path_converter(["items"]),
    item.item_create_converter,
    item.item_converter,
  )
}

pub fn update() -> glitr.Route(String, item.CreateItem, item.Item) {
  glitr.Route(
    http.Post,
    http.Http,
    "localhost",
    2345,
    True,
    utils.id_path_converter(["items"]),
    item.item_create_converter,
    item.item_converter,
  )
}

pub fn delete() -> glitr.Route(String, Nil, String) {
  glitr.Route(
    http.Delete,
    http.Http,
    "localhost",
    2345,
    False,
    utils.id_path_converter(["items"]),
    utils.no_body_converter(),
    glitr.JsonConverter(json.string, dynamic.string),
  )
}
