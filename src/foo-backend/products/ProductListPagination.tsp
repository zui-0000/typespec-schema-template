import "../../common/model/index.tsp";

@summary("ProductListPagination")
model ProductListPagination {
  totalCount: TotalCount;
  totalPages: TotalPages;
  currentPage: CurrentPage;
  perPage: PerPage;
}
