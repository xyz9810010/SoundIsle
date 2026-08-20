# SoundIsle Dependency DAG

## Allowed High-Level Imports
- Presentation → Domain/Application/Playback public interfaces
- Application/Playback coordinator → Domain + Repository contracts
- Repository implementation → Domain + Provider/LocalDataSource contracts
- Provider implementation → Network/secure auth infrastructure + Provider DTOs
- LocalDataSource → RDB/Preferences/FileStorage infrastructure
- Infrastructure → platform APIs

## Forbidden Cycles
No package may import back upward into its caller layer.

Examples of forbidden cycles:
- Domain ↔ Presentation
- Provider ↔ Repository implementation in both directions
- PlayerStateStore ↔ ViewModel
- Database ↔ Domain service
- NetworkClient ↔ Provider-specific UI

## Enforcement
When tooling permits, add static/module dependency checks. At minimum, architecture tests or code-review scripts should detect forbidden package references.
