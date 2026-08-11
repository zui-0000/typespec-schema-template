import "./model/index.tsp";

@summary("CreateProductResponse")
model CreateProductResponse {
  // 採番された ID。クライアントはこれを使って GET /products/{id} を呼べる。
  id: ProductId;
}
