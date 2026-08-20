# SoundIsle Error Presentation Policy

Not every error is a Toast.

Use:
- inline error for content-area failure;
- banner/status for persistent connectivity/offline state;
- toast/snackbar for short actionable/transient user feedback;
- blocking dialog only for decisions that truly require immediate user action.

Repeated equivalent transient errors are deduplicated/debounced.

Technical error details remain available through diagnostics, not dumped into normal user-facing messages.
