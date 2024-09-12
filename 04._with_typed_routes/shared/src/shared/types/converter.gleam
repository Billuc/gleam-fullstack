import gleam/dynamic
import gleam/json

pub type JsonEncoder(a) =
  fn(a) -> json.Json

pub type JsonDecoder(a) =
  fn(dynamic.Dynamic) -> Result(a, List(dynamic.DecodeError))

pub type JsonConverter(a) {
  JsonConverter(encoder: JsonEncoder(a), decoder: JsonDecoder(a))
}

pub type PathEncoder(a) =
  fn(a) -> List(String)

pub type PathDecoder(a) =
  fn(List(String)) -> Result(a, Nil)

pub type PathConverter(a) {
  PathConverter(encoder: PathEncoder(a), decoder: PathDecoder(a))
}
