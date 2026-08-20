# SoundIsle

HarmonyOS-native, API-driven, local-first, playback-centric Subsonic music client.

This repository is the HarmonyOS/ArkTS **application** project. The normative
architecture/engineering specifications live in
`SoundIsle_V26_280Cycles_ArchitectureChallenge/`.

## Status
- Current milestone: **M2** (first complete playback chain: browse → play → pause/seek/next/previous).
- Build + 86 unit tests verified; real Navidrome integration (9/9) and first-song + A→B track-switch playback verified on device (nova 14 Pro).

## Project layout (M0)
```text
AppScope/                    # application-level config (bundleName, icon, label)
entry/
  src/main/ets/
    entryability/            # EntryAbility (app entry; initializes Composition Root)
    pages/                   # navigation shell entry (Index)
    composition/             # CompositionRoot + AppContainer (constructor injection)
    presentation/            # UI (tabs: Home/Library/Search/My/Player)
    domain/                  # models, errors, repository contracts
    data/                    # repository implementations (M0 in-memory skeletons)
    providers/               # Provider contract + OpenSubsonicProvider skeleton
    playback/                # playback state contracts + in-memory state skeletons
    infrastructure/          # Logger, NetworkClient, storage abstractions
  src/test/                  # baseline unit tests (@ohos/hypium)
build-profile.json5
hvigorfile.ts
build.ps1                    # one-command clean build
```

## Build
```powershell
./build.ps1
```

See `SoundIsle_V26_280Cycles_ArchitectureChallenge/BUILDING.md` for the exact toolchain
record and test commands.
