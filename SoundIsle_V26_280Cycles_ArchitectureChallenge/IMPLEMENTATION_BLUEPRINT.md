# SoundIsle Implementation Blueprint

## M0 Minimal Skeleton
M0 creates structure, contracts and build/test confidence — not fake product features.

Suggested logical packages/modules:
```text
app/
presentation/
domain/
data/
providers/
playback/
infrastructure/
```

Exact HarmonyOS module/package layout must follow the real project/toolchain discovered in the repository.

## M0 Must Exist
- Composition Root
- navigation shell
- Domain identity/model skeleton
- Repository interfaces
- Provider interface
- Playback interfaces
- NetworkClient abstraction
- Preferences/RDB/SecureStorage/FileStorage abstractions
- Logger
- baseline tests
- exact build instructions

## M0 Must NOT Pretend To Exist
- real Navidrome browsing
- real playback
- downloads
- gapless
- provider completeness

## M1 Adds
- ServerProfile
- Secure credential flow
- OpenSubsonic/Navidrome ping/auth
- capability discovery
- artists/albums/songs/search read path
- pagination
- DTO→Domain mapping
- real integration tests
