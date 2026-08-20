# SoundIsle Release Gates

## RC Build
Must be produced from a clean working tree or documented clean checkout using recorded toolchain versions.

## Required Evidence
- commit SHA
- DevEco Studio / HarmonyOS SDK / Hvigor / ohpm versions
- automated test summary
- real Navidrome integration result
- device matrix for P0 media/system features
- migration result
- open P2/P3 issues
- VERIFY limitations

## Stop-Ship
- any P0/P1 defect
- credential exposure
- user-data loss
- stale playback request can replace current media
- background/AVSession critical failure
- cache cleanup can delete downloads
- migration cannot be demonstrated safe
- release cannot be reproduced

## Provider Labels
- FIRST_CLASS
- BETA
- IMPLEMENTED_UNVERIFIED
- DISABLED

UI and release notes must never present an unverified provider as First-Class.

## Release Configuration Gate
A Debug build cannot satisfy the full release gate alone. At least one RC/Release configuration must execute the P0 playback path and verify signing/permissions/background declarations/feature gates.

## Secret Scan
Release artifacts/configuration must be checked for test credentials, internal endpoints, verbose secret-bearing logs and developer-only flags.
