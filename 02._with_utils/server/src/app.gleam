import app/db
import app/router
import app/web
import gleam/erlang/process
import mist
import wisp
import wisp/wisp_mist

pub fn main() {
  wisp.configure_logger()

  let secret_key_base = wisp.random_string(64)
  use conn <- db.get_db()

  let context = web.Context(conn)
  let handler = router.handle_request(_, context)
  let assert Ok(_) =
    handler
    |> wisp_mist.handler(secret_key_base)
    |> mist.new
    |> mist.port(2345)
    |> mist.start_http

  process.sleep_forever()
}
