# SoundIsle Audio Architecture

## 1. Playback Chain
```text
User tap
→ QueueSeed + Origin
→ UserPlaybackIntent = PLAY
→ new PlaybackGeneration
→ PlaybackResolver
→ AudioSource
→ PlaybackEngine.prepare()
→ PlayerStateStore
→ Playing
→ ArkUI + AVSession
```

## 2. Core State Dimensions
Keep orthogonal state instead of one giant enum:
- current MediaKey
- UserPlaybackIntent: PLAY / PAUSE
- Engine state
- PlaybackGeneration
- pending/cancellable operation
- PendingSeek
- PlaybackInhibitor
- Queue state

## 3. Source Resolution
PlaybackResolver considers:
1. valid local download
2. requested quality policy
3. current network policy
4. server route
5. original vs transcode
6. fresh stream URL

A downloaded file is preferred only when it satisfies the current PlaybackPolicy, except offline mode where usable local media wins.

## 4. Recovery
NetworkChanged alone never rebuilds a stream.
```text
real read/playback failure
→ consume remaining buffer where possible
→ capture position
→ refresh AudioSource
→ switch route if needed
→ transcode if policy permits
→ prepare
→ seek
→ resume only if UserPlaybackIntent == PLAY and no inhibitor blocks playback
```
Retries are bounded.

## 5. Race Safety
- New media selection creates a new PlaybackGeneration.
- Old results may never replace current media.
- Engine mutations such as prepare/seek/reset/source replacement are serialized.
- Pending seek collapses to the newest requested position.
- Prepared does not imply Playing.

## 6. Interruptions
Unexpected Bluetooth/output route loss pauses effective playback.
System interruption may resume only if the user still wants playback and no blocking inhibitor remains.
User pause always wins over automatic resume.

## 7. Gapless / ReplayGain / Crossfade
- Stable normal transitions: P0.
- Best-effort Gapless: P1.
- Sample-accurate Gapless: VERIFY before product claims.
- ReplayGain only ships after correct Gain/Peak/Preamp/clipping behavior is verified.
- Crossfade is deferred until core playback is stable.

## 8. Evidence
Never display Lossless/Hi-Res/Original based only on source metadata. UI must reflect the actual AudioSource being played.


## 9. Normative State Specification
`PLAYBACK_STATE_MACHINE.md` is the normative source for event/state transitions. If prose here conflicts with that table, fix the conflict before implementation rather than choosing silently.

## 10. Unit Convention
Position and duration crossing the SoundIsle domain boundary use integer milliseconds.
