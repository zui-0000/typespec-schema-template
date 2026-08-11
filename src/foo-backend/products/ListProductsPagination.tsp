import "../../common/pagination/index.tsp";

@summary("ListProductsPagination")
model ListProductsPagination {
  totalCount: TotalCount;
  totalPages: TotalPages;
  currentPage: CurrentPage;
  perPage: PerPage;
}
