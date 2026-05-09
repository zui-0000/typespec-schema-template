import "../../common/model/index.tsp";

@summary("UserListPagination")
model UserListPagination {
  totalCount: TotalCount;
  totalPages: TotalPages;
  currentPage: CurrentPage;
  perPage: PerPage;
}
