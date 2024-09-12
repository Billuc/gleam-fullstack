import lustre_http
import shared/types/item

pub type Msg {
  ProductAdded(name: String)
  ProductRemoved(id: String)
  QuantityChanged(id: String, update: item.CreateItem)
  ServerCreatedItem(Result(item.Item, lustre_http.HttpError))
  ServerSentItems(Result(List(item.Item), lustre_http.HttpError))
  ServerUpdatedItem(Result(item.Item, lustre_http.HttpError))
  ServerDeletedItem(Result(String, lustre_http.HttpError))
}
