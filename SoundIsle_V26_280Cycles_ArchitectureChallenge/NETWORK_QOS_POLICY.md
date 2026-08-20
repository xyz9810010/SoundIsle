# SoundIsle Network QoS Policy

Network consumers have priorities.

Conceptual order:
1. active playback stream/source refresh
2. user-visible interactive metadata
3. artwork/lyrics
4. background downloads/prefetch

Rules:
- downloads have bounded concurrency;
- background work may yield when playback is buffering/recovering;
- network transition does not blindly recreate PlayerController/queue;
- stream recovery preserves PlaybackGeneration/currentMediaKey/position;
- Provider requests still obey per-server limits and retry policy.

QoS is a policy boundary, not permission for PlaybackEngine to become an HTTP scheduler.
