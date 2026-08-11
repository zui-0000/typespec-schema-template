import "./ListProductsPagination.tsp";
import "./ListProductsResult.tsp";

@summary("ListProductsResponse")
model ListProductsResponse {
  products: ListProductsResult[];
  pagination: ListProductsPagination;
}
