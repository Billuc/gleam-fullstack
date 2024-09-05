import app/web
import gleam/string_builder
import wisp.{type Request, type Response}

pub fn handle_request(req: Request, ctx: web.Context) -> Response {
  use _req <- web.middleware(req)

  case wisp.path_segments(req) {
    _ -> wisp.not_found()
  }
}
