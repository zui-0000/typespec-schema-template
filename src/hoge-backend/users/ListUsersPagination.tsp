import "../../common/pagination/index.tsp";

@summary("ListUsersPagination")
model ListUsersPagination {
  totalCount: TotalCount;
  totalPages: TotalPages;
  currentPage: CurrentPage;
  perPage: PerPage;
}
