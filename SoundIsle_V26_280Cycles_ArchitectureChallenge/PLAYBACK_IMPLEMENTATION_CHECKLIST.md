# SoundIsle Playback Implementation Checklist

Before merging any M2+ playback PR:

## Media Selection
- create/increment PlaybackGeneration;
- cancel or invalidate stale resolve/prepare work;
- commit current media only for current generation.

## Before Engine Start
Re-check:
- generation is current;
- UserPlaybackIntent == PLAY;
- no blocking inhibitor;
- prepared source matches currentMediaKey.

## Callbacks
Every async engine callback that can mutate current state must verify it belongs to the current source/generation.

## Seek
UI drag position is presentation-only until a controlled seek command is committed. Do not flood the engine with every pointer movement.

## Route Loss
Unexpected headphone/Bluetooth loss defaults to a safe pause rather than silently continuing through speaker, unless a clearly documented platform/product policy says otherwise.

## Persistence
Position writes are throttled and lifecycle-flushed; never synchronously write every progress tick.
