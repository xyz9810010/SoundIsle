# SoundIsle History & Scrobble Policy

## Separate Concepts
- PlaybackAttempt: media was prepared/started.
- RecentPlay: meaningful listening occurred.
- CompletedPlay: completion threshold reached.
- Scrobble: optional remote reporting.

Do not treat a one-second accidental tap as a completed/meaningful play.

## Thresholds
Exact thresholds are configurable/verified during implementation and must be centralized, not duplicated across UI/provider code.

## Privacy
Local history is local user data. Remote scrobbling is capability- and setting-dependent and must not be required for playback.
