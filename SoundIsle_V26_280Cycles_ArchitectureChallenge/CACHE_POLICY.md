# SoundIsle Cache Policy

## Cache Classes
- metadata
- cover art
- lyrics
- temporary audio
- diagnostics temporary files

## Principles
- Cache is disposable.
- Downloads are not cache.
- Durable user data is not cache.
- Actively used cache entries may be pinned temporarily.

## Eviction
Use bounded size + LRU/TTL as appropriate.
Do not evict:
- a local file currently being played;
- a temporary file currently being verified;
- a resource referenced by an in-flight operation without safe fallback.

## Artwork
Cache key includes `serverId + coverArtId + requestedSize`.
List pages request thumbnail-sized art; player/detail pages may request larger assets.

## Clear Cache
The UI must explicitly state that clearing cache does not delete downloads, local playlists, favorites, history, or server profiles.

## Freshness Triggers
Metadata/lyrics/artwork cache may refresh on:
- TTL expiry
- explicit user refresh
- relevant server/media validator change
- server/version change
- provider response indicating stale resource

Offline UI may use stale cache but should expose an offline/stale state when freshness matters.
