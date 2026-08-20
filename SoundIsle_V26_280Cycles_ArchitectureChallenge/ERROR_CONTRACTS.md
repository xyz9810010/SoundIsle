# SoundIsle Error Contracts

## Boundary Rule
Each layer translates lower-level errors into its allowed error vocabulary.

```text
Platform/HTTP
→ InfrastructureError
→ Provider/Repository DomainError
→ PresentationError
```

## Never Cross UI Boundary
Raw exceptions, HTTP library types, stack traces, AVPlayer-native error objects, SQL exceptions.

## Playback
PlayerController exposes stable player error categories/state. AVPlayer-specific errors are adapted inside PlaybackEngine.

## Provider
Provider maps protocol-specific error codes to stable provider/domain categories.

## Persistence
Database corruption/migration/storage errors are not converted into fake empty results.
