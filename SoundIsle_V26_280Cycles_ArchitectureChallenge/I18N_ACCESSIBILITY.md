# SoundIsle Internationalization & Accessibility

## Internationalization
- User-facing strings live in localization resources, not business logic.
- Metadata remains Unicode and is not transliterated destructively.
- Layout tolerates long translated strings.
- Search and sort must not assume ASCII.

## Accessibility
- semantic control labels
- readable play/pause/favorite/download state
- large-font support
- no color-only state
- minimum touch-target policy
- screen-reader-friendly progress information
- reduced-motion support where platform/user setting exists

## Test Content
Include:
- Chinese
- English
- Japanese
- Korean
- emoji
- mixed-script titles
- very long strings

## Queue Reordering
Drag-and-drop must not be the only way to reorder queue items. Provide an accessible equivalent such as Move Up/Move Down or platform-supported accessibility actions.
