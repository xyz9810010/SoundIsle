# SoundIsle Playback State Machine

The player uses orthogonal state dimensions rather than one oversized enum.

## State Dimensions

### UserPlaybackIntent
`PLAY | PAUSE`

### EnginePhase
`IDLE | RESOLVING | PREPARING | READY | PLAYING | BUFFERING | SEEKING | COMPLETED | RECOVERING | ERROR | RELEASED`

### PlaybackInhibitor
Zero or more:
`SYSTEM_INTERRUPTION | ROUTE_LOST | FATAL_ERROR | APP_POLICY`

### Pending
- playbackGeneration: integer
- pendingSeekMs?: integer
- activeOperationToken?: cancellable token

## Effective Playback Rule
Audio may start/continue only when:
```text
UserPlaybackIntent == PLAY
AND Engine is ready/capable
AND no blocking inhibitor exists
AND operation belongs to current PlaybackGeneration
```

## Key Transitions

| Current | Event | Action | Next |
|---|---|---|---|
| IDLE/PAUSED | Play(media/queue) | new generation, resolve source | RESOLVING |
| RESOLVING | UserPause | intent=PAUSE; resolution may continue | RESOLVING |
| RESOLVING | SourceResolved current gen | serialize prepare | PREPARING |
| RESOLVING | SourceResolved stale gen | ignore | unchanged |
| PREPARING | Prepared + intent PLAY + no inhibitor | start | PLAYING |
| PREPARING | Prepared + intent PAUSE | stay ready | READY |
| PREPARING | Seek(x) | replace pendingSeek=x | PREPARING |
| PLAYING | Seek(x) | serialize seek | SEEKING |
| SEEKING | Seek(y) | newest target wins | SEEKING |
| PLAYING | BufferingStart | retain intent | BUFFERING |
| BUFFERING | BufferingEnd | resume if effective rule allows | PLAYING/READY |
| PLAYING/BUFFERING | NetworkChanged | do not rebuild solely for event | unchanged |
| any active | Read/stream failure | enter bounded recovery | RECOVERING |
| RECOVERING | SourceRecovered | prepare+seek captured position | PREPARING |
| any active | Unexpected route loss | add ROUTE_LOST inhibitor, pause effective output | READY/PAUSED effect |
| any | UserPause | intent=PAUSE | engine-specific |
| any | UserPlay | intent=PLAY; start only if no inhibitor | engine-specific |
| PLAYING | TrackCompleted | advance QueueManager | RESOLVING/COMPLETED |
| any | NewMedia | increment generation, cancel stale ops | RESOLVING |

## Race Invariants
- Old generation callbacks never mutate current media state.
- A seek target from an old generation is discarded.
- AVSession never writes state directly; it emits controller commands.
- UI never flips to PLAYING solely because the user tapped Play.
- User PAUSE always prevents automatic resume.

## Persistence
Persist queue/current media/play mode/position on throttled checkpoints and lifecycle boundaries, not every position tick.

## Normative Invariants
Also obey `SYSTEM_INVARIANTS.md`.

Before any engine `start()`:
1. re-read current `UserPlaybackIntent`;
2. confirm no blocking inhibitor;
3. confirm operation generation is current;
4. confirm prepared source media matches currentMediaKey.

Do not rely on a check performed earlier in the async chain.
