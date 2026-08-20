# SoundIsle Core Data Model

## Design Rules
- Remote IDs are always `string`.
- Every remote media object is namespaced by `MediaKey`.
- Domain models are immutable/value-oriented where practical.
- Remote DTOs never enter UI directly.
- Time durations/positions use **milliseconds as integer values** throughout the domain unless a platform API requires another unit.
- Byte sizes use integer bytes.
- Bitrate uses bits-per-second when represented numerically.
- Nullable/optional fields are explicit.

## MediaKey
```text
MediaKey {
  providerId: string
  serverId: string
  mediaType: SONG | ALBUM | ARTIST | PLAYLIST
  remoteId: string
}
```

## Song
```text
Song {
  key: MediaKey
  title: string
  artistNames: string[]
  artistIds?: string[]
  albumId?: string
  albumName?: string
  albumArtist?: string
  composer?: string
  durationMs: number
  trackNumber?: number
  discNumber?: number
  year?: number
  genres: string[]
  coverArtId?: string
  suffix?: string
  codecHint?: string
  bitrateBps?: number
  sampleRateHz?: number
  bitDepth?: number
  channels?: number
  sizeBytes?: number
  serverStarred?: boolean
  serverRating?: number
}
```

## Album
```text
Album {
  key: MediaKey
  name: string
  artistNames: string[]
  albumArtist?: string
  year?: number
  genres: string[]
  coverArtId?: string
  songCount?: number
  durationMs?: number
}
```

## Artist
```text
Artist {
  key: MediaKey
  name: string
  albumCount?: number
  coverArtId?: string
}
```

## QueueItem
Queue entries store stable identity plus a minimal display snapshot so the queue can still render after restart/offline:
```text
QueueItem {
  key: MediaKey
  titleSnapshot: string
  artistSnapshot: string
  albumSnapshot?: string
  coverArtIdSnapshot?: string
  durationMs?: number
}
```

Do not persist a final stream URL in `QueueItem`.

## QueueSeed
```text
QueueSeed {
  items: QueueItem[]
  currentIndex: number
  origin: PlaybackOrigin
}
```

## PlaybackOrigin
```text
PlaybackOrigin {
  kind: ALBUM | PLAYLIST | ARTIST | SEARCH | HOME | FAVORITES | DOWNLOADS | SINGLE
  key?: MediaKey
  title?: string
}
```

## AudioSource
Represents what is **actually** being played:
```text
AudioSource {
  mediaKey: MediaKey
  uri: string
  requestHeaders?: Map<string,string>
  routeId: string
  sourceType: LOCAL_DOWNLOAD | REMOTE_ORIGINAL | REMOTE_TRANSCODE
  codec?: string
  container?: string
  bitrateBps?: number
  sampleRateHz?: number
  bitDepth?: number
  channels?: number
  contentLengthBytes?: number
  expiresAtEpochMs?: number
}
```

## ServerProfile
Non-sensitive fields only:
```text
ServerProfile {
  id: string
  name: string
  providerType: OPENSUBSONIC | JELLYFIN | EMBY | AUDIO_STATION | PLEX
  primaryUrl: string
  lanUrl?: string
  alternativeUrls: string[]
  username?: string
  credentialRef: string
  enabled: boolean
  createdAtMs: number
  updatedAtMs: number
}
```

## LocalFavorite
```text
LocalFavorite {
  mediaKey: MediaKey
  createdAtMs: number
  serverSyncState: NOT_REQUESTED | PENDING | SYNCED | FAILED | UNSUPPORTED
}
```

## LocalPlaylist
Playlist items reference `MediaKey`; optional snapshots are retained for orphaned/offline display.

## Invariants
- `currentIndex` must be within queue bounds or queue is empty.
- A downloaded file marked READY must exist and have passed the configured integrity check.
- Cache entries may be discarded at any time; durable user records may not.
- `serverId + providerId + remoteId` identity must never be collapsed to plain `remoteId`.


## Orphaned Media
A durable local record may outlive its remote server/media object.

Use:
```text
OrphanState = ACTIVE | REMOTE_MISSING | SERVER_REMOVED | UNKNOWN
```

Durable local favorites/playlists/history/downloads keep enough display snapshot data to remain understandable. Orphaned records are not silently deleted.

## Favorite Sync State
Server sync state uses:
`LOCAL_ONLY | SYNC_PENDING | SYNCED | SYNC_FAILED | UNSUPPORTED`

Local favorite persistence is authoritative for the user's SoundIsle action. Remote sync failure never deletes the local favorite.
