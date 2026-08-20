# SoundIsle Roadmap

## M0 — HarmonyOS / ArkTS Engineering Baseline
Buildable project, architecture skeleton, CI, logging, storage abstractions, navigation and design-system baseline.

## M1 — Real Navidrome / OpenSubsonic
Server profile, secure credentials, ping/auth, library browsing, search, album/artist/song models and provider contract tests.

## M2 — First Complete Playback Chain
QueueSeed, QueueManager, PlaybackResolver, AVPlayer engine, PlayerStateStore, seek, next/previous, generation/cancellation, first real song playback.

## M3 — Daily Playback Experience
AVSession, background playback, lock screen, Bluetooth/media controls, interruptions, queue persistence, recovery, readable errors.

## M4 — Offline / Advanced Playback
Downloads, offline resolver, cache separation, quality policy, best-effort gapless, verified audio information, advanced diagnostics.

## M5+ — Additional Providers
Jellyfin / Emby / AudioStation / Plex promoted individually after real verification.


## Cross-Milestone Rule
Each milestone closes with TECH_DEBT_GATE and upgrade-compatibility review for any persisted state already shipped/tested.
