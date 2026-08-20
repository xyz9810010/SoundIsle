# SoundIsle Chaos / Adversarial Test Plan

## User Chaos
Random sequences over:
play, pause, next, previous, seek, queue edit, clear queue, background/foreground, server switch.

Assert invariants:
- current MediaKey matches audible source;
- no stale generation wins;
- user PAUSE prevents auto-resume;
- queue index remains valid;
- no crash.

## Device Chaos
- Bluetooth connect/disconnect loops
- repeated audio interruptions
- low-memory/page recreation
- storage-full events
- network flap

## Server Chaos
- delayed responses
- connection drop mid-body
- malformed/oversized JSON
- wrong MIME/media
- redirect loops/host changes
- 5xx/auth expiration

## AI/Release Chaos
- clean checkout build
- Release build critical path
- feature flags verified
- no test credentials/config packaged
