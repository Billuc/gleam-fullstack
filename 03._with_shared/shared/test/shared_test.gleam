import gleam/dynamic
import gleam/result
import gleeunit
import gleeunit/should
import shared/types/item

pub fn main() {
  gleeunit.main()
}

// gleeunit test functions end in `_test`
pub fn hello_world_test() {
  1
  |> should.equal(1)
}

pub fn dynamic_test() {
  item.Item("1", "Carrots", 2)
  |> dynamic.from
  |> dynamic.element(0, dynamic.dynamic)
  |> result.map(dynamic.classify)
  |> should.equal(Ok("Atom"))
}
