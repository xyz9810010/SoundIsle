# SoundIsle Persistence Contract

## Principle
On-disk records are not the same thing as Domain objects.

## Layers
```text
RDB Row / JSON Record
→ Persistence DTO
→ Mapper
→ Domain
```

## Required Metadata
Persisted versioned blobs/snapshots include a schema/version field where forward evolution matters.

## Queue Snapshot
Queue persistence stores:
- queueVersion
- ordered QueueItem persistence records
- currentMediaKey
- currentIndex
- positionMs
- playMode
- repeatMode
- shuffle traversal/history identity data
- updatedAtMs

## Cache Record
Cache records include:
- cacheKey
- source/server
- freshness/expiry metadata
- record format version
- payload reference

## Rule
Adding a Domain field does not automatically mean changing the database. Persistence changes require migration consideration.
