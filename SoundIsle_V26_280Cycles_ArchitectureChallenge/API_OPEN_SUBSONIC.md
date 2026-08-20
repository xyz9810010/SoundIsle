# SoundIsle OpenSubsonic / Navidrome API

## 1. V1 Position
Navidrome / OpenSubsonic is the First-Class server target for SoundIsle V1.

## 2. Provider Responsibilities
OpenSubsonicProvider owns:
- authentication and server capability discovery
- music library browsing
- artist/album/song lookup
- search
- stream/source resolution
- cover art
- lyrics where supported
- optional server star/playlist/scrobble operations

## 3. Domain Boundary
All remote IDs are strings.
```text
JSON
→ defensive DTO parse
→ Mapper
→ Domain Model
```
Never use `JSON as Song`.

## 4. Core Read APIs
Prioritize the ID3-style OpenSubsonic/Subsonic flow:
- ping
- getOpenSubsonicExtensions when supported
- getArtists
- getArtist
- getAlbum
- getSong
- getAlbumList2
- search3
- stream
- getCoverArt

Add lyrics, playlists, star/rating and scrobble through capability-aware adapters.

## 5. Stream Rules
Song never stores a permanent stream URL.
```text
MediaKey
→ PlaybackResolver
→ Provider
→ route
→ quality policy
→ fresh AudioSource
```

## 6. User Data Rules
Local favorite/history/playlists are durable local state.
Server star/playlist writes are optional synchronization behavior.
Local queue remains authoritative even if server play-queue endpoints exist.

## 7. Failure Handling
Translate HTTP/protocol/provider failures into domain errors. UI receives understandable presentation states, not raw protocol exceptions.

## 8. Compatibility Tests
Maintain fixtures and contract tests for supported Navidrome/OpenSubsonic responses. Unknown fields are tolerated; malformed required fields fail defensively.


## 9. Capability Snapshot
A server profile stores a capability snapshot with protocol/server version and discovered OpenSubsonic extensions. UI and Provider code use capability checks, never only `serverName == Navidrome`.

## 10. Authentication
Authentication implementation must be based on the actual supported server/spec behavior. Credentials are never persisted in ordinary RDB tables or logged.

## 11. Pagination Contract
Any potentially large endpoint must expose paged/incremental repository behavior. The UI must not require a full library download before first content.

## 12. API Assumption Rule
If an endpoint/parameter is not confirmed by the actual OpenSubsonic/Navidrome documentation used during implementation, mark it as an assumption and verify before coding against it.
