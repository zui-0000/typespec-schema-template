import "../../common/model/index.tsp";
import "./ProductListPagination.tsp";
import "./ProductListResult.tsp";

@summary("ProductListResponse")
model ProductListResponse {
  result: ProductListResult[];
  meta: CommonResponseMeta;
  pagination: ProductListPagination;
}
