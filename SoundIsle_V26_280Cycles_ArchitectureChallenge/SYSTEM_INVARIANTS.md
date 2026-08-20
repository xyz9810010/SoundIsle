# SoundIsle System Invariants

## Playback
1. At most one `PlaybackGeneration` may commit audible-current state.
2. `currentMediaKey` identifies the media; queue index is derived/secondary.
3. UI current media, Queue current media and Engine current source must correspond to the same generation/media identity.
4. User PAUSE always blocks automatic resume.
5. Recovery is bounded and must terminate in Playing/Ready/Error/Completed.

## Queue
1. Empty queue → no valid current index.
2. Non-empty queue → `0 <= currentIndex < size`.
3. Reordering/removal preserves current media by `MediaKey` when that media still exists.
4. Shuffle history/traversal persists by media identity, not raw index.

## Downloads
1. `COMPLETED` implies final file exists and verification succeeded.
2. Temp files are never exposed as completed downloads.
3. Cache deletion cannot delete completed downloads.

## Cache
1. Cache is never authoritative durable user state.
2. Cache miss must have a refetch/fallback/offline behavior.
3. Active/pinned resources are not evicted unsafely.

## Database/Migration
1. Schema version moves monotonically forward per supported migration.
2. Failed migration never silently replaces durable data with empty schema.
3. Durable writes requiring consistency are transactional where practical.
4. Playback hot path does not synchronously depend on non-critical history/log writes.

## Feature Gates
Effective access is constrained by release policy, actual capability and allowed user preference. User preference cannot elevate a release-disabled feature.

## Security
Sensitive credentials never enter ordinary logs, RDB user tables, or cross-host redirects without explicit authorization.
