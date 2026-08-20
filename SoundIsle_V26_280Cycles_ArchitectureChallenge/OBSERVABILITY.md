# SoundIsle Observability

## Local-First Diagnostics
Diagnostics are local by default and are not uploaded automatically.

## Categories
`APP | NETWORK | PROVIDER | PLAYER | DOWNLOAD | DATABASE | SYSTEM`

## Correlation
A playback attempt should carry a correlation id across:
`PlayIntent → Resolve → HTTP → Prepare → Playing/Failure`

## Playback Events
Record sanitized:
- media identity hash/reference
- generation id
- source type
- route id
- prepare duration
- buffering start/end
- seek
- recovery steps
- final error category

## Export Package
May include:
- app/version/commit
- HarmonyOS/device summary
- server type/version/capability summary
- sanitized logs
- audio/source summary
- recent state transitions

Never include passwords/tokens/api keys/full credential-bearing URLs.

## Metrics
Do not require cloud telemetry for V1. Baselines may be gathered through local diagnostics and test harnesses.

## Privacy Levels
Default diagnostic export minimizes media titles and server addresses. Credentials and sensitive headers are never loggable. Full user-readable metadata may only be included through an explicit user-facing diagnostic choice.

## Identifier Privacy
Default logs use short/stable hashes or redacted references rather than the complete `serverUrl + remoteId` identity.

## Last Playback Failure Summary
Diagnostic export may include:
- playback generation
- source type
- route id/reference
- error category
- recovery steps attempted
- final player state

All fields remain subject to redaction.
