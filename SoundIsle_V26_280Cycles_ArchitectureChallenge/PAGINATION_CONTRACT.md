# SoundIsle Pagination Contract

Potentially large repository results must be incremental.

Generic concept:
```text
Page<T> {
  items: T[]
  nextCursor?: string
  hasMore: boolean
}
```

Offset-based providers may adapt their offset/count to this domain contract.

Rules:
- UI never requires complete library retrieval before rendering first page.
- Search/list cancellation guards apply per request generation.
- Repository owns provider-specific pagination adaptation.
- Provider DTO pagination metadata does not leak directly into Presentation.

## Concurrent Page Merge
Results must belong to the current query/request generation. Out-of-order page responses are merged only when their page/cursor relationship is valid; arrival order alone never defines list order.
