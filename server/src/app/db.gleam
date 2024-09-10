import sqlight

pub fn get_db(f: fn(sqlight.Connection) -> a) -> a {
  use conn <- sqlight.with_connection(":memory:")

  let migration =
    "
        create table if not exists items(id, name, amount);
    "
  let assert Ok(Nil) = sqlight.exec(migration, conn)

  f(conn)
}
