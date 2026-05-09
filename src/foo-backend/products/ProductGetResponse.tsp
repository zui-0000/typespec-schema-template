import "../../common/model/index.tsp";
import "./ProductGetResult.tsp";

@summary("ProductGetResponse")
model ProductGetResponse {
  result: ProductGetResult;
  meta: CommonResponseMeta;
}
