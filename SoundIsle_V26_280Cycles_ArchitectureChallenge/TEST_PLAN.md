# SoundIsle Test Plan

## Quality Layers
1. Local unit tests
2. Provider contract tests
3. Integration tests
4. HarmonyOS device tests
5. User acceptance tests

## P0 Playback Red-Team Cases
- A→B→C rapid selection; only C may play.
- Seek while preparing.
- Pause while source is resolving.
- Wi-Fi→cellular during playback.
- LAN route failure with WAN recovery.
- Bluetooth disconnect during playback.
- Background/lock screen for extended playback.
- URL expiration and source refresh.
- Download completes while same media is playing.
- App/process recovery with queue persistence.

## Stop-Ship
- stale request replaces current media
- UI says paused while audio continues, or persistent inverse
- unexpected speaker playback after route loss
- background core playback fails
- cache cleanup deletes downloads/user data
- migration loses user data
- infinite recovery/retry loop

## Persona Tests
- first-time ordinary user
- heavy queue user
- audiophile
- NAS/LAN HTTP user
- weak-network user
- offline user
- Bluetooth/car user
- 10k/50k+ library user
- large-font/accessibility user
- multi-server user

## VERIFY on Real Devices
- AVSession/lock screen
- background longevity
- Bluetooth/car controls
- Gapless level
- ReplayGain correctness
- format matrix
- Tap-to-Audio baseline
- memory/power behavior


## Acceptance Linkage
Every P0 feature must reference one or more IDs in `ACCEPTANCE_CRITERIA.md`.

## Data Migration Gate
Automated tests must include:
- fresh DB creation;
- N-1 → N migration when an N-1 public/beta schema exists;
- migration interruption/failure behavior;
- no silent table drop.

## State-Machine Property Tests
Where feasible, generate action sequences over play/pause/new-media/seek/interruption/network events and assert invariants from `PLAYBACK_STATE_MACHINE.md`.


## V13 Additional Red-Team Cases
- malicious filename/path metadata
- redirect to a different host with Authorization present
- 20MB+ artwork / oversized JSON response
- local favorite referencing removed server
- migration interrupted halfway
- download temp file exists but DB says RUNNING after restart
- download DB says COMPLETED but file missing
- cache eviction while art/audio is in use
- multilingual/very-long metadata
- provider returns conflicting capability/version information

## V14 Additional Cases
- shuffle → previous → restart → next consistency
- repeat-one natural completion vs manual Next
- remove/move current queue item during playback
- two servers using the same remote song ID
- expired URL with clock skew
- Range ignored / wrong Content-Range
- missing download file after app restart
- concurrent queue/history/download DB writes
- stale search response after newer query
- foldable/window rebuild while playing

## V15 Multidimensional Cases
- offline cached library while server unreachable
- server removal during active download
- malformed/descending lyric timestamps
- Unicode/CJK/mixed-script sorting and search history
- Mini Player large-text/screen-reader behavior
- background playback without unrelated background polling
- database-open failure must not auto-reset durable data
- feature-gated capability must remain inaccessible until promoted

## V16 Lifecycle Cases
- onboarding error classification
- month-long retention growth
- 8-hour playback soak
- 50k/100k library behavior
- 24-hour server outage
- URL edit preserving serverId
- capability refresh after server upgrade
- force-kill restart without autoplay
- upgrade and future-schema downgrade protection
- corrupted durable DB without auto-reset
- very large download library cold start
- changed server file with same remoteId
- clock/timezone changes
- server removal credential cleanup and local-asset preservation

## V17 Adversarial Cases
- randomized player command sequence invariants
- Bluetooth flap loops
- repeated audio interruption loops
- storage-full during download/cache write
- low-memory/page recreation
- provider response timeout / mid-body disconnect
- oversized JSON/artwork limits
- wrong MIME/media payload
- redirect loop / cross-host auth stripping
- Release build critical-path smoke
- packaged config contains no test secrets

## V18 Evidence-Driven Cases
- persisted shuffle survives restart without order regeneration
- queue edit remaps shuffle by MediaKey, not stale index
- server favorite sync failure preserves local favorite
- stale/offline cache state is distinguishable
- queue reorder accessible without drag
- disabled feature gate cannot be enabled by stale user preference
- backup restore conflict behavior is explicit
- diagnostic playback-failure summary remains redacted

## V19 Invariant Tests
- currentMediaKey/queue/engine source identity agreement
- user PAUSE rechecked at engine start boundary
- queue index bounds after arbitrary edits
- shuffle identity history survives edits/restart
- remote writes classified by retry safety
- completed download/file existence invariant
- cache miss does not destroy durable behavior
- migration re-run does not double-apply
- recovery never exceeds budget
- one route failure does not imply global network unavailable

## V20 Contract Boundary Tests
- Provider DTO cannot be consumed directly by UI
- unchecked DTO→Domain cast prohibited by lint/review rule
- UI command path goes through PlayerController
- PlaybackEngine has no Database/Provider implementation dependency
- package dependency graph contains no forbidden cycle
- persistence DTO migration independent from Domain field additions
- raw platform errors do not cross Presentation boundary
- numeric conversion rejects unsafe integer values where exactness matters

## V22 M0/M1 Simulation Cases
- composition root is the only production dependency assembly point
- page code does not instantiate Repository/Provider/Playback core
- secret cannot fall back to Preferences/RDB
- reverse-proxy path prefix survives endpoint construction
- failed server validation leaves no durable broken profile
- repository returns Domain Page<T>, not provider DTO pagination
- capability discovery failure degrades conservatively
- build commands match real repository/toolchain evidence

## V23 PR Review Cases
- page/ViewModel has one presentation-state authority
- disposed/stale async UI request cannot commit
- credential write + profile persistence failure compensates safely
- sensitive auth query/header values are redacted
- out-of-order pagination does not reorder logical pages
- recycled list item cannot receive stale artwork
- stale AVPlayer prepare callback cannot become current
- headphone/Bluetooth route loss follows safe-pause policy
- seek drag does not flood engine commands
- download concurrency is globally bounded
- repeated equivalent transient errors are deduplicated
- PR tests include meaningful behavior/state assertions

## V24 Cross-Milestone / Device Cases
- M1 MediaKey can flow into M2 PlaybackResolver without protocol DTO leakage
- credential changes do not require Player to cache secrets
- active playback takes network priority over background downloads
- migration failure does not wipe user database
- old queue/settings snapshots migrate or degrade safely
- Page destruction does not destroy app-scoped playback core
- process restart restores queue/media/position without unintended autoplay
- lock-screen/system controls enter PlayerController
- media card metadata comes from current PlayerState
- Bluetooth reconnect does not auto-resume by default after route-loss pause
- network switch recovery preserves generation/media/position semantics
- ENOSPC never produces COMPLETED download

## V25 Production-Reality Cases
- capability behavior tested across more than one server/version when available
- reverse-proxy subpath survives endpoint resolution
- HTML proxy/login response is not parsed as empty JSON data
- self-signed TLS is rejected unless explicit supported trust is configured
- high-latency metadata and long-lived streams use appropriate timeout classes
- 100k-song-scale design does not require startup full-object materialization
- huge playlist/queue construction avoids UI-thread blocking
- corrupted/unsupported audio fails without corrupting queue
- zero/unknown duration does not expose invalid seek semantics
- oversized artwork/lyrics respect resource budgets
- crash during queue snapshot cannot restore torn state as trusted
- crash during download commit cannot create false COMPLETED state
- optional compatibility gate degrades safely
- diagnostic bundle contains no credentials/media identity by default

## V26 Architecture-Challenge Checks
- Repository boundary exists without mechanical one-entity-one-repository proliferation
- PlayerStateStore contains playback state, not unrelated global app state
- Provider contract contains no speculative future-server methods
- V1 core journey is not blocked by advanced audio features
- new interface satisfies ABSTRACTION_RULES
- small task documentation burden matches TASK_RISK_LEVELS
- tests prefer behavior/fakes over mock call-count assertions
