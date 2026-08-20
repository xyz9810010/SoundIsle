// Pagination contract (PAGINATION_CONTRACT.md). Offset-based providers adapt
// their offset/count to this domain shape; the caller owns the offset cursor.
export interface Page<T> {
  readonly items: T[];
  readonly hasMore: boolean;
}
