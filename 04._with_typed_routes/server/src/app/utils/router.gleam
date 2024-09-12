import app/types/error
import app/utils/route_utils
import gleam/result
import gleam/string
import pprint
import shared/types/routes
import wisp

pub type Router {
  Router(req: wisp.Request)
}

pub fn for(req: wisp.Request) -> Result(Router, wisp.Response) {
  Ok(Router(req))
}

pub fn try(
  router_res: Result(Router, wisp.Response),
  route: routes.Route(p, b, res),
  handler: fn(route_utils.RouteOptions(p, b)) -> Result(res, error.AppError),
) -> Result(Router, wisp.Response) {
  use router <- result.try(router_res)

  pprint.debug(string.append("Trying route... Current path : ", router.req.path))

  let result = route_utils.receive(router.req, route, handler)

  case result {
    Ok(response) -> Error(response)
    Error(Nil) -> Ok(router)
  }
}

pub fn unwrap(router_res: Result(Router, wisp.Response)) -> wisp.Response {
  case router_res {
    Ok(_) -> wisp.not_found()
    Error(response) -> response
  }
}
