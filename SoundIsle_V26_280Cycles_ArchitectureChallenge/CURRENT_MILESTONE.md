# Current Milestone — M2

Status: ACTIVE

## Goal
First complete playback chain: browse -> select song -> resolve AudioSource -> AVPlayer
play -> pause/seek/next/previous -> queue works. (This is the first key usable version.)

## Required Outcomes
- PlaybackResolver resolves a Song MediaKey into a fresh AudioSource (stream URL).
- PlaybackEngine (AVPlayer) prepares/plays/pauses/seeks/stops/releases real audio.
- PlayerController wires QueueManager + PlaybackEngine + PlayerStateStore with PlaybackGeneration / cancellation.
- Queue: play album/song list -> QueueSeed -> play; next/previous; seek.
- UI: tap song/album plays; player reflects real state.
- First real song playback verified on device.

## Non-Goals (do NOT do in M2)
- AVSession / system media control / lock screen / background playback (M3).
- Downloads / offline / cache expansion (M4).
- Gapless / ReplayGain / crossfade (M4).
- Jellyfin / Emby / AudioStation / Plex (M5+).
- UI beautification / recommendations.

## Exit Gate
First real song plays on device; pause/seek/next/previous work; queue works; PROJECT_STATUS updated with evidence.

## Milestone Exit
Pass TECH_DEBT_GATE before M3.
