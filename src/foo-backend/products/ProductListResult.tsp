import "./model/index.tsp";
import "../../common/model/index.tsp";

@summary("ProductListResult")
model ProductListResult {
  id: ProductId;
  name: ProductName;
  price: ProductPrice;
}
