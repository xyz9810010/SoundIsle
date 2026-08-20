# SoundIsle Presentation State Policy

For one feature/screen flow, choose one authoritative Presentation State.

Example:
```text
ServerListState {
  status
  items
  error?
  refreshing
}
```

Do not separately maintain equivalent `loading`, `items`, `error` state in both page and ViewModel.

Async updates must verify:
- request generation/current query;
- ViewModel is still active when lifecycle matters;
- result still belongs to the bound MediaKey/item.

Artwork/image binding must validate identity before applying an async result to a recycled list item.
