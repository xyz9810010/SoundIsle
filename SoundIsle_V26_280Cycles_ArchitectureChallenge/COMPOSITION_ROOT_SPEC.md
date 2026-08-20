# SoundIsle Composition Root Specification

Exactly one application-level composition root creates long-lived dependencies.

Conceptual assembly:
```text
Platform Infrastructure
→ NetworkClient / Storage / Logger
→ ProviderFactory / LocalDataSources
→ Repository implementations
→ Playback application services
→ ViewModels / UI entry dependencies
```

Rules:
- Pages do not instantiate repositories/providers/player core.
- Provider implementations are created from ServerProfile/credential session data.
- Application-scoped objects are reused according to lifecycle.
- Test composition may replace infrastructure with fakes, but must preserve the same public contracts.
