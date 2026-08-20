# SoundIsle Recovery Budget

## Purpose
Prevent infinite recovery loops and unpredictable user waits.

## Playback Recovery Stages
Potential stages:
1. refresh current source
2. switch route
3. fallback to transcode if policy permits
4. terminal error

Each stage has a bounded attempt count and cancellation on:
- new PlaybackGeneration
- user stop/pause policy where applicable
- fatal auth/permission errors
- explicit terminal error

## Network Classification
Distinguish:
- `ROUTE_FAILURE`
- `SERVER_UNREACHABLE`
- `NETWORK_UNAVAILABLE`
- `AUTH_FAILURE`
- `SOURCE_EXPIRED`

Do not label the entire app offline because one route failed.
