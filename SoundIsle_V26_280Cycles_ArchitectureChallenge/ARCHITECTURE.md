# SoundIsle Architecture

## 1. Architecture Goal
SoundIsle is a HarmonyOS-native, API-driven, Local-First User State, Playback-Centric music client.

## 2. Layering
```text
Presentation
├── Pages
├── Components
├── ViewModels
└── UI State

Domain
├── Media Models
├── Repository Contracts
├── Playback Policy
└── Focused UseCases

Data
├── Repositories
├── Local DataSources
├── Remote DataSources
└── Cache

Providers
└── OpenSubsonicProvider (V1 First-Class)

Playback
├── PlayerController
├── PlayerStateStore
├── QueueManager
├── PlaybackResolver
├── PlaybackRecovery
├── PlaybackEngine
└── AVSessionAdapter

Infrastructure
├── NetworkClient
├── ArkData/RDB
├── Preferences
├── SecureStorage
├── FileStorage
├── Logger
└── TaskScheduler
```

## 3. Hard Rules
- Player lifecycle is application-scoped, never page-scoped.
- PlayerStateStore is the playback state authority.
- QueueManager is the real-time local queue authority.
- Pages never directly instantiate Player/Repository/Provider.
- AppStorage is not a business database.
- Remote DTOs never become Domain models by unsafe casts.
- No giant MusicManager, global万能 EventBus, or one-UseCase-per-button architecture.

## 4. Data Authority
- Remote music metadata: server authority, locally cacheable.
- Favorites/playlists/history/settings: durable local user state.
- Credentials: secure storage only.
- Cache: disposable.
- Downloads: user assets, never deleted by cache cleanup.

## 5. Dependency Composition
Use a Composition Root + constructor injection. Keep framework-level DI optional for V1.

## 6. Concurrency
Use platform async APIs for HTTP/database/player work. Worker/TaskPool only for actual CPU-heavy work. All stale playback async results must be cancellable or guarded.

## 7. Provider Boundary
Provider implementations translate server protocols into stable domain contracts. Provider-specific behavior must not leak into core player UI.


## 8. Required Contract Documents
Implementation must also obey:
- `DATA_MODEL.md`
- `DATABASE_SCHEMA.md`
- `PLAYBACK_STATE_MACHINE.md`
- `ERROR_MODEL.md`
- `UI_SPEC.md`
- `ACCEPTANCE_CRITERIA.md`

## 9. Time and Identity Conventions
- Domain duration/position: integer milliseconds.
- File sizes: bytes.
- Remote IDs: strings.
- All remote media identity: `MediaKey`, never plain remote ID.

## 10. Contract Boundary References
Normative:
- `MODULE_CONTRACTS.md`
- `TYPE_SYSTEM_RULES.md`
- `DEPENDENCY_DAG.md`
- `PERSISTENCE_CONTRACT.md`
- `ERROR_CONTRACTS.md`
- `NAMING_LAYOUT_RULES.md`
