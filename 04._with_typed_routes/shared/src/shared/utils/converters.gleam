import gleam/bool
import gleam/json
import gleam/list
import shared/types/converter

pub fn simple_path_converter(root: List(String)) -> converter.PathConverter(Nil) {
  converter.PathConverter(fn(_) { root }, fn(segs) {
    use <- bool.guard(segs == root, Ok(Nil))
    Error(Nil)
  })
}

pub fn id_path_converter(root: List(String)) -> converter.PathConverter(String) {
  converter.PathConverter(fn(id) { list.append(root, [id]) }, fn(segs) {
    let reverse_root = list.reverse(root)
    case list.reverse(segs) {
      [id, ..rest] if rest == reverse_root -> Ok(id)
      _ -> Error(Nil)
    }
  })
}

pub fn no_body_converter() -> converter.JsonConverter(Nil) {
  converter.JsonConverter(fn(_) { json.null() }, fn(_) { Ok(Nil) })
}
