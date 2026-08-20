# SoundIsle Tasks

## M0 Task Order
- [x] M0-01 Inspect repository and existing HarmonyOS project state
- [x] M0-02 Record actual DevEco/HarmonyOS SDK/Hvigor/ohpm build environment
- [x] M0-03 Establish module/package structure from ARCHITECTURE.md
- [x] M0-04 Create Composition Root and lifecycle ownership rules
- [x] M0-05 Implement Domain IDs/models from DATA_MODEL.md
- [x] M0-06 Create Repository contracts
- [x] M0-07 Create OpenSubsonicProvider contract skeleton
- [x] M0-08 Create Playback contracts consistent with PLAYBACK_STATE_MACHINE.md
- [x] M0-09 Create NetworkClient abstraction
- [x] M0-10 Create Preferences/RDB/SecureStorage/FileStorage abstractions consistent with DATABASE_SCHEMA.md
- [x] M0-11 Create structured Logger categories
- [x] M0-12 Create app navigation shell: Home/Library/Search/My/Player
- [x] M0-13 Add baseline tests, acceptance-ID linkage, and build commands
- [x] M0-14 Add CI/build verification if repository environment permits
- [x] M0-15 Update PROJECT_STATUS and evidence

> M0 exit-gate note (2026-08-20): all 15 tasks complete. Exit gate MET — clean build
> + launch on real device (nova 14 Pro) + 14 baseline tests all verified. Signed HAP
> installed, navigation shell (Home/Library/Search/My/Player) rendered, no crash.
> Evidence in PROJECT_STATUS.md.

## M1 Task Order
- [x] M1-01 Real infrastructure: NetworkClient (http) + SecureStorage (asset) + PreferencesStore (preferences) + RdbStore (relationalStore), wired into Composition Root — device re-verified (install + launch + 5 tabs, no crash)
- [x] M1-02 ServerProfile + ServerRepository (RDB persistence)
- [x] M1-03 OpenSubsonic/Navidrome ping + auth + connection flow (real device PASS: connect + RDB persist + SecureStorage restore)
- [x] M1-04 DTO→Domain mapping for artists/albums/songs/search + pagination (code + tests done; real-device browse/search = DEVICE_TEST_REQUIRED)
- [x] M1-05 Add-server credential compensation flow (completed inside M1-03: addServer compensation + removeServer cleanup)
- [x] M1-06 Integration tests against representative server responses (real Navidrome read-API PASS + real-fixture tests)
- [x] M1-07 Update PROJECT_STATUS + evidence (M1 complete; TECH_DEBT_GATE passed)

## M2 Task Order
- [x] M2-01 PlaybackResolver + OpenSubsonic stream resolution (Song -> fresh AudioSource) — real Navidrome stream verified (HTTP 206 audio/mpeg, range/seek ok)
- [x] M2-02 PlaybackEngine (AVPlayer) — AvPlayerPlaybackEngine + state mapping (audio = DEVICE_TEST_REQUIRED)
- [x] M2-03 Real PlayerController — DefaultPlayerController + PlaybackGeneration/cancellation (unit-tested)
- [x] M2-04 Queue play — QueueSeed -> play; next/previous; seek (covered by M2-03 controller)
- [x] M2-05 UI wiring — Search tap song -> play (singleSongSeed); player reflects state
- [ ] M2-06 Tests + real Navidrome stream integration + device playback verification (stream PASS; first-song play + A→B track switch DEVICE-CONFIRMED; pause/seek/next/previous still DEVICE_TEST_REQUIRED)

## Rule
AI executes tasks in order. A blocked task is recorded as BLOCKED with evidence; it must not be silently skipped.

## Required Docs Convention
Each implementation task should be annotated in issue/commit/work log with:
`required_docs: [...]`

For M0 use `M0_M1_ACCEPTANCE.md` and `IMPLEMENTATION_BLUEPRINT.md` as mandatory references.
