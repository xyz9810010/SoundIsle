# SoundIsle Resource & Input Limits

Remote servers are untrusted input.

## HTTP/JSON
Implement configurable/safe limits for:
- response body size where practical;
- maximum list/page size accepted into memory;
- string/metadata length sanity;
- artwork dimensions/decoded memory;
- redirect hop count.

If a response exceeds safe bounds, fail with `InvalidResponse/ResourceLimit` rather than risking OOM.

## Artwork
Never decode full-resolution artwork for small list cells.
Reject/scale pathological dimensions.

## Logs
Bound local log size/rotation.

## Retry/Timeout
Every network class has explicit connect/read/request timeout and bounded retry.
No user interaction may wait forever on a provider call.

## Media Inputs
Bound artwork decoded pixels/dimensions and lyric payload/line/timestamp complexity. Large libraries/playlists must not require full Domain-object materialization on app startup or UI thread.
