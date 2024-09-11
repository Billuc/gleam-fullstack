import lustre_http
import types/model

pub type Msg {
  ProductAdded(name: String)
  ProductRemoved(id: String)
  QuantityChanged(id: String, update: model.UpsertItem)
  ServerCreatedItem(Result(model.ShoppingItem, lustre_http.HttpError))
  ServerSentItems(Result(List(model.ShoppingItem), lustre_http.HttpError))
  ServerUpdatedItem(Result(model.ShoppingItem, lustre_http.HttpError))
  ServerDeletedItem(Result(String, lustre_http.HttpError))
}
