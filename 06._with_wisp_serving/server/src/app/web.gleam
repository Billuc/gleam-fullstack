import sqlight
import wisp

pub type Context {
  Context(db_conn: sqlight.Connection)
}

pub fn middleware(
  req: wisp.Request,
  handle_request: fn(wisp.Request) -> wisp.Response,
) -> wisp.Response {
  let req = wisp.method_override(req)
  use <- wisp.log_request(req)
  use <- wisp.rescue_crashes
  use req <- wisp.handle_head(req)

  let assert Ok(priv) = wisp.priv_directory("app")
  let static_dir = priv <> "/static"
  use <- wisp.serve_static(req, under: "/static", from: static_dir)

  handle_request(req)
}
