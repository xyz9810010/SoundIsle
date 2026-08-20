# SoundIsle Module Contracts

## Dependency Direction
```text
Presentation
    ↓
Domain Contracts / Application Services
    ↓
Repositories
    ↓
Provider / Local DataSource
    ↓
Infrastructure
```

Playback is application-owned and consumes Domain contracts:
```text
Presentation → PlayerController
PlayerController → QueueManager / PlaybackResolver / PlaybackEngine
PlaybackResolver → Repository/Provider contracts
PlaybackEngine → HarmonyOS media APIs only
```

## Forbidden Dependencies
- UI → AVPlayer directly
- UI → Provider DTO
- Provider → UI
- PlaybackEngine → Database
- PlaybackEngine → Provider implementation
- Repository → concrete server brand checks scattered across code
- Domain → ArkUI/HarmonyOS page types

## Boundary Data
Each boundary has explicit request/response types. Mutable implementation objects never cross boundaries by reference when avoidable.

## Core Ownership
Exactly one application-scoped active PlayerController/PlayerStateStore/QueueManager pair per app process.
