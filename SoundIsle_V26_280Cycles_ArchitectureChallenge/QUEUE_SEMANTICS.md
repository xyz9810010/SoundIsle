# SoundIsle Queue Semantics

## Modes
`SEQUENTIAL | SHUFFLE`
Repeat: `OFF | ALL | ONE`

## Shuffle
Shuffle maintains a stable randomized traversal and playback history. Queue edits must not randomly regenerate the already-traversed history. Previous follows actual playback history.

## Repeat
- ONE: natural completion repeats current item.
- ONE + manual Next: user intent wins; advance normally.
- ALL: queue end wraps.
- OFF: queue end completes playback.

## Editing Current Queue
- Remove non-current: preserve current MediaKey, recompute index.
- Move current: preserve current MediaKey and playback.
- Remove current: choose the next logical item; if none, previous/complete according to remaining queue.
- Clear queue: stop playback and clear current context after user confirmation where appropriate.

## Persistence
Persist queue order, current MediaKey/index, mode, repeat mode, shuffle traversal/history and position checkpoints.

## Shuffle Persistence Hardening
Persist:
- queueVersion
- shuffled media identity order
- current shuffled position
- playback history identities

When queue content changes, remap by MediaKey rather than raw index. Entries removed from the queue are removed from future traversal but remain interpretable in playback history where needed.

A restart must not silently regenerate a new shuffle order for an active persisted queue.
