# SoundIsle Error Model

## Layers
```text
Platform/HTTP error
→ InfrastructureError
→ DomainError
→ PresentationError
→ user-facing action
```

## Domain Error Categories

### AuthenticationError
Examples: invalid credentials, expired auth.
User action: re-login/edit account.
Retry: no blind retry.

### NetworkUnavailable
No network path.
User action: use downloads / retry after connectivity.

### TimeoutError
Connect/read timeout.
Retry: bounded according to request type.

### TlsError
Certificate/handshake issue.
Never auto-disable certificate validation.

### ServerUnavailable
5xx/server offline.
Retry: bounded for idempotent reads; do not duplicate writes.

### PermissionDenied
Server role/capability missing.
No retry until account/server configuration changes.

### UnsupportedCapability
Feature not implemented by server.
UI should hide/disable capability when known.

### InvalidResponse
Malformed/invalid required data.
Log sanitized context; do not crash UI.

### MediaUnsupported
Current source cannot be played.
Recovery: alternative source/transcode if policy allows.

### PlaybackSourceExpired
Refresh AudioSource.

### PlaybackFatal
Exhausted recovery.
User sees actionable failure.

### StorageFull
Pause/fail download; never delete downloads automatically.

### LocalFileCorrupt
If online, remote fallback may be offered; offline shows clear unavailable state.

### DatabaseError
Durable user-data failure. Higher severity than cache failure.

## Retry Matrix
- GET/read/idempotent metadata: bounded retry allowed.
- stream recovery: bounded, state-aware.
- favorite/playlist mutation: retry only with idempotency/pending-operation strategy.
- delete/update writes: never blindly replay if duplication/corruption is possible.

## User-Facing Rule
Never show raw stack traces, `ECONNREFUSED`, protocol enum names, or HTTP exception text as primary UI. A collapsible diagnostic detail may contain sanitized technical data.
