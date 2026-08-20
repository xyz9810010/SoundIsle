# SoundIsle Project Status

## Baseline
Specification: MASTER_PLAN V26 — 280-cycle architecture-challenge review
Current milestone: M0
Implementation status: M2 ACTIVE — M2-01..M2-05 done; first-song playback + A→B track switch DEVICE-CONFIRMED; pause/seek/next/previous still DEVICE_TEST_REQUIRED

## Quality State
- Product baseline: APPROVED
- Architecture review: APPROVED
- User council: APPROVED
- 15-cycle playback review: CONVERGED
- multi-AI style defect review: CONVERGED
- V13 deep red-team (15 additional cycles): CONVERGED
- HarmonyOS real-device verification: DONE (M0 launch/navigation-shell verified on nova 14 Pro; see device evidence)
- Real Navidrome integration: PENDING

## Current Risks
- HarmonyOS real-device background behavior
- AVSession/device-control behavior
- actual Navidrome compatibility
- long-session power/memory
- verified Gapless level
- format compatibility

## Evidence
Populate this section with build/test/device evidence as implementation progresses.

### M0 baseline evidence (2026-08-20)
- Toolchain discovered: DevEco Studio 6.1.1.300, HarmonyOS 6.1.1 (API 24, SDK 6.1.1.125), Hvigor 6.24.4, ohpm 6.1.2.285, DevEco-bundled Node v18.20.1, JBR 21.0.8; host Windows 11 (10.0.26100). Recorded in BUILDING.md.
- Clean build: `./build.ps1` → BUILD SUCCESSFUL (assembleHap, unsigned). Output `entry/build/default/outputs/default/entry-default-unsigned.hap`.
- Baseline tests: `hvigorw test` → BUILD SUCCESSFUL, 14 unit tests passed (MediaKey identity, DomainError, favorite/playlist repositories, playback state/queue). Report `entry/.test/default/outputs/test/reports/index.html`.
- Module structure (presentation/domain/data/providers/playback/infrastructure/composition), Composition Root, domain models, repository/provider/playback contracts, NetworkClient + storage abstractions, Logger, and the 5-tab navigation shell (Home/Library/Search/My/Player) compile under the real ArkTS (API 24) toolchain.
- NOT claimed: real Navidrome browsing/playback, real persistence (RDB/preferences/secure storage are M0 in-memory skeletons), app launch on device/emulator (still pending).

### M0 device verification (2026-08-20) — PASSED
- Device: real HarmonyOS nova 14 Pro (MIA-AL00), API 24, OpenHarmony-6.1.1.120, UDID 9B335B39048BE39A014F8EE63403A830A0BEDABCADBF8B0C020B7E4BCCE29210.
- Signing: auto-signing generated `default_SoundIsle_*` debug profile for `com.soundisle.app`; product now references `signingConfig: "default"`. Build produces `entry-default-signed.hap`.
- Install: `hdc install entry-default-signed.hap` → `install bundle successfully`.
- Launch: `hdc shell aa start -a EntryAbility -b com.soundisle.app` → `start ability successfully`; process `com.soundisle.app` (PID 12448) stays alive.
- Navigation shell: UI dump (`uitest dumpLayout`) shows `pagePath: pages/Index`, type `Tabs`, with tab labels Home / Library / Search / My / Player; Player tab renders `Phase: IDLE`, `Intent: PAUSE` (Composition Root → PlayerStateStore → PlayerController wiring works at runtime).
- User visual confirmation (2026-08-20): Home page displays; Library page displays; bottom Navigation Shell works; no launch crash. Real-device launch evidence obtained.
- Crash check: hilog has no CRASH / FATAL / SIGSEGV / JsError / ArkTS error for `com.soundisle.app`. Only benign entries: launcher (sceneboard) suggestion/featureMap noise and a renderer `ueaClient-rtg_interface set rtg attr failed (rtgId:-1;rate:120)` hint (invalid-argument frame-rate hint, not a crash).

### M0 storage-skeleton review (which are legit M0 vs M1 prerequisites)
- Legit M0 (contracts + in-memory skeleton to make the Composition Root compile/test): the four abstractions `PreferencesStore`, `RdbStore`, `SecureStorage`, `FileStorage` (interfaces) plus `InMemory*` skeletons. These are honest skeletons, not production persistence.
- Must be implemented BEFORE M1 (M1 depends on real infrastructure):
  - `SecureStorage` real impl (M1 acceptance: credential flow; ServerProfile stores no plaintext) — @ohos.security.asset (AssetStoreKit).
  - `PreferencesStore` real impl — non-sensitive settings + ServerProfile fields.
  - `RdbStore` real impl — servers/favorites/playlists tables per DATABASE_SCHEMA.md.
  - `NetworkClient` real impl (@ohos.net.http + error mapping) — M1 server validation/auth.
- Not required before M1: `FileStorage` real impl (cache/downloads belong to later milestones); the abstraction already exists.
- M0 is NOT closed by implementing these now — that would be doing M1 work to close M0.

### M1-01 real infrastructure (2026-08-20) — DONE (compile + unit-test)
- Real HarmonyOS APIs used (inspected from the actual API-24 SDK `.d.ts`, not guessed):
  - NetworkClient → `@kit.NetworkKit` (`http.createHttp`, `request()`, `RequestMethod`, `HttpDataType`) + pure error mapping to `DomainError`.
  - SecureStorage → `@kit.AssetStoreKit` (`asset.add/query/remove`, `Tag`, `Accessibility.DEVICE_FIRST_UNLOCKED`, `ReturnType.ALL`; string↔Uint8Array via `@kit.ArkTS` `util.TextEncoder/TextDecoder`). Credentials ONLY here.
  - PreferencesStore → `@kit.ArkData` `preferences.getPreferences/get/put/flush/delete`.
  - RdbStore → `@kit.ArkData` `relationalStore.getRdbStore/executeSql/querySql` + `ResultSet` (SecurityLevel.S2).
  - Composition Root → `@kit.AbilityKit` `common.Context` (passed from EntryAbility).
- Files: NEW `infrastructure/NetworkErrorMapping.ets`, `infrastructure/storage/HarmonyStorage.ets`; MODIFIED `infrastructure/NetworkClient.ets` (real client), `composition/CompositionRoot.ets` (context + real wiring), `entryability/EntryAbility.ets`; tests `NetworkErrorMapping.test.ets` (+ `List.test.ets`).
- Build: `assembleHap` → BUILD SUCCESSFUL, signed HAP produced. 25 non-fatal ArkTS linter hints on HarmonyStorage.ets `@kit` calls (API-version/usage notes; device is API 24, all APIs supported).
- Tests: `hvigorw test` → BUILD SUCCESSFUL, 21 unit tests pass (14 prior + 7 new NetworkErrorMapping).
- Device: reinstalled signed HAP successfully. Fresh launch re-verification is currently BLOCKED on the physical screen lock (developer-mode lock cannot be auto-unlocked) — not a code issue; M0 already proved launch.
- DEVICE_TEST_REQUIRED (M1-01 scope): real runtime behavior of asset/preferences/rdb/http is lazy and NOT yet exercised — it will be exercised by M1-02 (ServerRepository/RDB) and M1-03 (OpenSubsonic ping/auth over HTTP).
- M1-01 device re-verification (user-confirmed, 2026-08-20): signed HAP reinstalled; app launches; Home / Library / Search / My / Player all normal; 5-tab bottom navigation switches normally; no launch crash.

### M1-02 ServerProfile + ServerRepository (2026-08-20) — DONE (compile + unit-test)
- Domain model: `ServerProfile` stays a pure domain model in `domain/model/UserModels.ets` (id, name, providerType, primaryUrl, lanUrl?, alternativeUrls, username?, credentialRef, enabled, createdAtMs, updatedAtMs) — decoupled from any HarmonyOS RDB API; no future fields added.
- Interface: `domain/repository/ServerRepository.ets` = list/get/create/update/remove (create fails on duplicate, update fails on missing).
- Impl: `data/RdbServerRepository.ets` uses the `RdbStore` abstraction (NOT the raw relationalStore API) + `ServerProfileMapper` (ServerRow <-> ServerProfile) + `ServerDatabaseSchema` (versioned migration).
- DB schema (`servers`): id TEXT PK, name, provider_type, primary_url, lan_url, alternative_urls_json, username, credential_ref, enabled INTEGER, created_at_ms, updated_at_ms. No password/token/secret column — only `credential_ref` (points into SecureStorage/AssetStore).
- Migration: schema version via `RdbStore.getSchemaVersion()/setSchemaVersion()` (maps to relationalStore `RdbStore.version` = SQLite PRAGMA user_version). `SERVER_SCHEMA_VERSION=1`; `ensureServerSchema` applies migrations 1..N in order, never DROP/recreate, rejects a newer schema (no silent downgrade). Future versions append to the migration list.
- URL: `domain/url/ServerUrl.ets` (`normalizeBaseUrl` + `joinUrl`) per URL_CONSTRUCTION.md — handles http/https, trailing slash, base path, IP, domain, port; no "//" or lost subpath.
- Error mapping: RDB exceptions -> `DomainError('DATABASE')` via `mapDatabaseError`.
- Files NEW: `domain/url/ServerUrl.ets`, `data/persistence/ServerDatabaseSchema.ets`, `data/ServerProfileMapper.ets`, `data/RdbServerRepository.ets`, tests (`ServerUrl/ServerProfileMapper/ServerDatabaseSchema/RdbServerRepository` + `FakeRdbStore` helper). MODIFIED: `ServerRepository.ets`, `StorageContracts.ets` (RdbValue + schema-version), `HarmonyStorage.ets`, `InMemoryStorage.ets`, `InMemoryRepositories.ets`, `CompositionRoot.ets`, `List.test.ets`.
- Build: `assembleHap` -> BUILD SUCCESSFUL. Tests: `hvigorw test` -> BUILD SUCCESSFUL, 45 unit tests (14 prior + 8 URL + 2 mapper + 6 schema + 8 repository + 7 NetworkErrorMapping). CRUD/migration/credential_ref/no-secret/error-mapping all covered.
- DEVICE_TEST_REQUIRED (M1-02): the actual relationalStore persistence (real RDB file write/read, schema version surviving app restart) is NOT yet exercised on device — that is covered in M1-03 (real Navidrome connection) / a device persistence run. Compile + host unit tests are NOT proof of on-device RDB persistence.

### M1-03 server connection flow (2026-08-20) — code + tests DONE; real connection = DEVICE_ACTION_REQUIRED
- OpenSubsonic auth (per Subsonic/OpenSubsonic salted-MD5 scheme): `token = hex(md5(password + salt))`, lowercase hex; query params `u/t/s/v/c/f` (v=1.16.1, c=SoundIsle, f=json). Salt = random alphanumeric (generateSalt). Password never sent in clear text and never logged.
- Endpoint called: `<baseUrl>/rest/ping.view` (canonical Subsonic; user's "/rest/ping" maps to this). Real MD5 via `@kit.CryptoArchitectureKit` `cryptoFramework.createMd('MD5')`.
- Response parsed defensively (status/version/type/serverVersion/openSubsonic); status=failed + error.code 30/40 -> AUTH_FAILED; malformed JSON -> INVALID_RESPONSE.
- Connection states: CONNECTING / CONNECTED / AUTH_FAILED / NETWORK_ERROR / TIMEOUT / SERVER_ERROR / INVALID_RESPONSE, mapped from DomainError categories (AUTHENTICATION->AUTH_FAILED, NETWORK_UNAVAILABLE->NETWORK_ERROR, TIMEOUT->TIMEOUT, TLS->NETWORK_ERROR, SERVER_UNAVAILABLE->SERVER_ERROR).
- Credential compensation (CREDENTIAL_COMPENSATION): addServer = ping -> putSecret(credentialRef) -> ServerRepository.create(profile); on create failure deletes the just-created credential (no orphan). removeServer = delete RDB profile then delete credential.
- Minimal UI: My tab = name/url/username/password + "连接并保存" + status (连接成功/认证失败/网络错误/连接超时/服务器错误/协议响应错误).
- Security redline: no password/token/full-auth-URL in logs (redactUrl redacts t/s; provider never logs); RDB stores only credential_ref; password only in SecureStorage.
- Files NEW: `domain/server/ServerConnection.ets`, `domain/server/ServerConnectionFlow.ets`, `providers/SubsonicAuth.ets`, `providers/PingDtos.ets`, `infrastructure/HarmonyMd5.ets`, `infrastructure/Hex.ets`; tests `SubsonicAuth/PingDtos/ServerConnectionFlow.test.ets`. MODIFIED: `providers/OpenSubsonicProvider.ets` (real ping), `providers/ProviderFactory.ets` (NetworkClient), `providers/Provider.ets` (extends ServerPinger), `composition/CompositionRoot.ets`, `presentation/tabs/MyTab.ets`, `List.test.ets`.
- Build: assembleHap BUILD SUCCESSFUL. Tests: hvigorw test BUILD SUCCESSFUL, 60 unit tests (auth token/salt/query/redaction, ping parse success/failed/invalid, error mapping, credential compensation, secret redaction, all prior tests).
- DEVICE_ACTION_REQUIRED: real Navidrome connection + real RDB/SecureStorage persistence on the device (see report). NOT yet verified — no fake PASS.

### M1-03 device round 1 (2026-08-20)
- Navidrome real connection: **PASS** (user confirmed) — entered name + http://192.168.5.3:4533 + username + password; "连接并保存" → real OpenSubsonic ping via NetworkKit → Navidrome returned ok. Real auth (salted MD5 token) verified against a real server.
- RDB/SecureStorage cross-process restore: **FAILED in round 1** — after force-kill + restart, the server-connection page showed empty fields. Root cause: the persistence WRITE was correct (relationalStore auto-commit + AssetStore), but the UI never loaded saved profiles back from RDB (restore path was missing).
- Fix: added `ServerConnectionFlow.listServers()/hasCredential()` + MyTab `aboutToAppear` load that restores name/url/username (password stays masked) and shows credential-presence. Files: `domain/server/ServerConnectionFlow.ets`, `presentation/tabs/MyTab.ets`, + restore-path unit test.
- Status: fix built + 61 unit tests pass; **real cross-process restore is DEVICE_TEST_REQUIRED** — awaiting user re-verification ("保存 → 完全结束 App → 重启 → 检查数据 → 再次连接").

### M1-03 device round 2 (2026-08-20)
- ServerProfile RDB persistence: **PASS** (name/url/username restored after restart; page shows "已保存").
- Navidrome real connection: **PASS** (re-entering password reconnects).
- SecureStorage/AssetStore credential restore: **FAILED in round 2** — reconnect still required password. Root cause: the credential WAS durably stored in AssetStore (asset.add succeeded; ALIAS == credentialRef), but the reconnect chain was NOT connected — the UI's connect flow always used the form password and never read the saved credential back via credentialRef.
- Fix (this round): `ServerConnectionFlow.reconnectServer(id)` = read profile from RDB -> `secureStorage.getSecret(credentialRef)` (AssetStore query ALIAS + RETURN_TYPE.ALL, TextDecoder) -> ping. MyTab now shows a "使用已保存凭据连接" button when a saved profile + credential exists (no password required). Password never re-entered and never persisted/displayed in plaintext.
- Tests: + SecureStorage contract test (write/read, missing, wrong alias, delete, update) + reconnect tests (recovers credential from SecureStorage; missing credential throws). Build + all 68 unit tests pass.
- Status: **SecureStorage restart restore = fixed, awaiting real-device re-verification** (保存 -> 完全结束 App -> 重启 -> 不输入密码 -> 点"使用已保存凭据连接" -> 连接成功).

### M1-03 final device acceptance (2026-08-20) — PASS
- Full flow verified on device: save real Navidrome + credential -> force-kill app -> restart.
- After restart: ServerProfile restored; page shows "凭据已保存"; password NOT refilled into UI; NO password re-entered; "使用已保存凭据连接" -> real server connected -> returns navidrome 0.61.2 (aa84e645).
- **M1-03 PASS**: real Navidrome authentication/HTTP (salted-MD5 token + NetworkKit), RDB cross-process persistence, SecureStorage/AssetStore credential restore, all verified on device. No fake/mock.

### M1-06 integration testing (2026-08-20) — real Navidrome integration PASS
- Dev machine reaches the real Navidrome (http://192.168.5.3:4533, navidrome 0.61.2 aa84e645, openSubsonic true, api 1.16.1).
- Authenticated read-API integration against the real server: **PASS** — ping (ok), getArtists, getAlbumList2, search3 all returned real data (harness `tools/navidrome_integration.ps1`).
- Auth-failure mapping verified against real server: bogus token -> code 40 -> AUTH_FAILED.
- DTO field correction (found via real responses): real Navidrome uses `genres` (array of `{name}`), NOT `genre` string; and does NOT return `year` in getAlbumList2/search3; songs carry `channelCount`/`samplingRate`/`bitDepth`. DTOs + mappers updated to match reality (no guessing).
- Real-fixture tests: `RealNavidromeFixtures.test.ets` (captured real responses); mapper tests updated (genres/channels/sampleRate/bitDepth). All unit tests pass, build SUCCESSFUL.
- Credentials are read only from env (`NAVIDROME_USER`/`NAVIDROME_PASS`) and are never written to any file, log, test, or git.

### M2 track-switch bug fix (2026-08-21) — DEVICE-CONFIRMED PASS
- Bug (user-reported): tap song B while A is playing → UI "正在播放" + phase/intent update to B, but speaker still plays A.
- Actual root cause (found via device hilog, not guessed): setting `AVPlayer.url` triggers an ASYNC `idle → initialized` transition. Calling `prepare()` immediately after `url =` reaches the player while it is still `idle`, so AVPlayer rejects it ("current state is not stopped or initialized, unsupport prepare operation"). This produced silence (and on the pre-refactor reuse path the old source kept playing). An earlier `reset()`-based fix was WRONG and reverted.
- Fix (final): (1) use a FRESH AVPlayer per media source — release the old player and create a new one, which starts in `idle` (the exact path the first play already follows); (2) after setting `url`, WAIT for the `initialized` state before calling `prepare()` (`waitForState` helper). Engine keeps the injectable `AvPlayerLike` abstraction (+ `MediaAvPlayerAdapter`) with hilog tracing of every state transition.
- Device evidence (2026-08-21): user confirmed song A plays and tapping song B audibly switches to B. hilog shows repeated `prepare done state=prepared → start: play()` across many distinct `stream?id=...` values (oppxJu9DoMvTUkrxDL1TUP, 1T5WaoVdHr5m4gY8LGfD2x, VwsKQDbk3JXflNWc40ctm4, …) — no more "unsupport prepare operation".
- Tests: `AvPlayerPlaybackEngine.test.ets` asserts switching A→B creates a NEW player, releases the old one, and actually loads B's url (86/86 unit tests pass); real Navidrome harness asserts two distinct songs have different stream ids (9/9).
- Known separate item (not the switch bug): one song (`O8tr59pWcyACjlIFklylKT`) reports "Unsupported Format: … unsupport container format type" on this device → `MEDIA_UNSUPPORTED` (engine throws, phase → ERROR). Device AVPlayer codec/container limitation; other songs stream fine. Tracked under format compatibility risk.

### M2-02..M2-05 playback chain (2026-08-20) — code + tests done; audio = DEVICE_TEST_REQUIRED
- M2-02: `AvPlayerPlaybackEngine` (AVPlayer via @kit.MediaKit: url + prepare/play/pause/seek/stop/release; stateChange/timeUpdate/seekDone/error -> listener). Pure `mapAvPlayerState` in `EngineStateMapping.ets` (unit-tested).
- M2-03: `DefaultPlayerController` wires QueueManager + PlaybackResolver + PlaybackEngine + PlayerStateStore with PlaybackGeneration (stale resolve/prepare dropped; user PAUSE blocks auto-start). Unit-tested (stale-resolution + pause-no-autostart).
- M2-04: queue play via `play(QueueSeed)` + next/previous/seek (covered by M2-03).
- M2-05: Search tap song -> play (`singleSongSeed`); player reflects state.
- Real Navidrome stream integration: PASS (HTTP 206 audio/mpeg, range/seek ok).
- Build + all unit tests pass. DEVICE_TEST_REQUIRED: actual AVPlayer audio output (first real song audible) — cannot be verified on the dev machine.

### M2-01 PlaybackResolver + stream resolution (2026-08-20) — PASS
- `OpenSubsonicProvider.resolveAudioSource(username, password, key)` builds a fresh `/rest/stream?id=<songId>&<auth>&format=raw` URL and returns an ephemeral `AudioSource` (sourceType=REMOTE_ORIGINAL, routeId=primaryUrl). URL never persisted.
- `playback/ProviderPlaybackResolver` resolves a Song MediaKey by loading the profile (by key.serverId) + credential, then delegates to the provider. Wired into Composition Root.
- Real Navidrome stream verified: HTTP 200/206, Content-Type audio/mpeg, range request returns 1024 bytes (seek-capable). `tools/navidrome_integration.ps1` now checks stream.
- Unit test `ProviderPlaybackResolver.test.ets` (server-scoped credential + AudioSource mapping). Build + all tests pass.

### M1 TECH_DEBT_GATE (2026-08-20) — PASSED
- P0 (correctness/data-loss/security blocker): NONE. No plaintext secret path (credentials only in SecureStorage/AssetStore; RDB only credential_ref); migrations non-destructive.
- P1 (high-risk architecture/playback/release): NONE.
- P2 (deferrable, named owner/target): capability snapshot not persisted into ServerProfile (owner: provider; target M2; risk: capabilities re-discovered per use — no correctness impact).
- P3 (cleanup): repository "not found"/"duplicate" throws plain Error (no NOT_FOUND category; owner domain/error; target M2); ~25 ArkTS linter hints on HarmonyStorage @kit calls (owner infrastructure); redactUrl covers only t=/s= (owner providers; target M2).
- Review checks: (1) contracts stable for M2 — yes; (2) no plaintext/data-loss path — yes; (3) migration path exists (servers schema v1, versioned ensureServerSchema) — yes; (4) M2 does not require bypassing boundaries (playback will use Provider/NetworkClient) — yes; (5) device-only unknowns explicitly DEVICE_TEST_REQUIRED (audio/background/lockscreen/bluetooth/permissions/lifecycle) — yes.

### M1 capability discovery (2026-08-20) — verified against real Navidrome
- `OpenSubsonicProvider.discoverCapabilities()` calls `getOpenSubsonicExtensions` (real endpoint) and builds conservative `ProviderCapabilities`: base Subsonic read/write APIs = true; extension-gated flags (lyrics via `songLyrics`, play-queue via `savePlayQueue`) only when advertised.
- Real Navidrome extensions: transcodeOffset, formPost, songLyrics, indexBasedQueue, transcoding → lyrics=true, playQueueSync=false (no savePlayQueue). Verified via `tools/navidrome_integration.ps1` (getOpenSubsonicExtensions PASS).
- Known follow-up: the discovered snapshot is not yet persisted into ServerProfile (API_OPEN_SUBSONIC #9) nor consumed by UI gating — the provider `capabilities` field remains conservative all-false until wired. Not blocking M1 read path.

### M1-04 browse/search read path (2026-08-20) — code + tests DONE; device verification = DEVICE_TEST_REQUIRED
- Pagination: `domain/Page.ets` `Page<T> { items, hasMore }` (PAGINATION_CONTRACT). Offset-based; hasMore = items.length >= pageSize.
- DTOs: `providers/OpenSubsonicDtos.ets` (Artist/Album/Song DTO + wrappers). Mappers: `providers/OpenSubsonicMappers.ets` (DTO -> Artist/Album/Song, MediaKey = OPENSUBSONIC + serverId + mediaType + remoteId; duration seconds -> ms).
- Provider read path: `OpenSubsonicProvider.listArtists` (getArtists.view, offset/count), `listAlbums` (getAlbumList2.view type=alphabeticalByName, offset/size), `search` (search3.view, songCount/songOffset). Each request authed via salted-MD5 token (u/t/s/v/c/f), parsed defensively; failed status -> DomainError.
- Layering fix: moved the Provider contract to `domain/provider/Provider.ets` (+ `ProviderFactory` interface); providers layer implements it. `domain/server/BrowseService.ets` loads saved profile + credential (SecureStorage) then reads via provider.
- Minimal UI: Library tab (load albums), Search tab (search songs) — real data, no beautification.
- Tests: `OpenSubsonicMappers.test.ets` (album/artist/song mapping, duration ms, hasMore, failed-auth -> AUTHENTICATION, malformed -> INVALID_RESPONSE). Build + all unit tests pass.
- Known deferred: capability discovery (getOpenSubsonicExtensions) not yet implemented — capabilities remain all-false (conservative); cover art image fetch + stream resolution are M2. `hasMore` uses the standard full-page heuristic (Subsonic omits total count).
- DEVICE_TEST_REQUIRED: real Navidrome browse/search (Library loads real albums, Search finds real songs, pagination) not yet run on device.

### M1-03 self-review
- SYSTEM_INVARIANTS (Security): credentials only in SecureStorage; RDB only credential_ref; no password/token in logs; redirect auth not forwarded. No invariant violated.
- PR_REVIEW_CHECKLIST: one vertical slice; no page-created deps; dependency DAG acyclic (hexEncode moved to infrastructure to avoid infra->providers violation); tests assert behavior (compensation, parse, redaction) not mock invocation. Known: hyphenated key "subsonic-response" handled by string-normalize before JSON.parse (ArkTS forbids index access); endpoint uses canonical ping.view.

### M1-02 self-review
- SYSTEM_INVARIANTS (Database/Migration): schema version moves monotonically forward; no DROP/recreate; rejects newer version (no silent downgrade). Security: servers table has no secret column; only credential_ref. No invariant violated.
- PR_REVIEW_CHECKLIST: one vertical slice; domain model decoupled from RDB; dependency DAG acyclic (data -> RdbStore abstraction -> infrastructure); no page-created deps; tests assert real CRUD behavior against an in-memory double (not mock invocation). Known item: repository "not found"/"duplicate" throw a plain Error (ERROR_MODEL has no NOT_FOUND category) — acceptable for M1-02, revisit if needed in M1-03.

### M1-01 self-review
- SYSTEM_INVARIANTS (Security): credentials never enter logs/RDB/Preferences — SecureStorage (asset) is the sole credential boundary; NetworkClient does not log headers; RDB servers table will store only `credential_ref`. No invariant violated.
- PR_REVIEW_CHECKLIST: one vertical slice; no second core store/manager; dependency DAG acyclic (infrastructure is lowest); no page-created deps; NetworkErrorMapping test asserts behavior (error categories), not mock invocation. Known limitation: `NetworkClient.buildHeader` currently forwards only `Accept` + `Authorization` (sufficient for OpenSubsonic V1 query-param auth).

- V14 extended red-team (Cycles 26–40): CONVERGED

- V15 multidimensional cross-review (Cycles 41–60): CONVERGED

- V16 lifecycle review (Cycles 61–80): CONVERGED

- V17 adversarial review (Cycles 81–100): CONVERGED

- V18 evidence-driven review (Cycles 101–120): CONVERGED

- V19 invariant review (Cycles 121–140): CONVERGED

- V20 contract/type-boundary review (Cycles 141–160): CONVERGED

- V21 lean-spec review (Cycles 161–180): CONVERGED

- V22 M0/M1 implementation simulation (Cycles 181–200): CONVERGED

- V23 hypothetical M0/M1/M2 PR review (Cycles 201–220): CONVERGED

- V24 M0→M3 technical-debt and real-device lifecycle review (Cycles 221–240): CONVERGED

- V25 post-V1 production compatibility/weak-network/large-library/media-corruption review (Cycles 241–260): CONVERGED

- V26 anti-overengineering / architecture challenge (Cycles 261–280): CONVERGED
