# SoundIsle Support Diagnostic Bundle

Purpose: let a user export enough technical evidence for support without exporting their music identity or credentials by default.

May include:
- app version/build
- HarmonyOS version/device class
- provider type/server capability summary
- anonymized error categories/counts
- recent playback state transitions without media titles
- migration/schema versions
- feature gates
- network class (not credential-bearing URLs)

Must not include by default:
- password/token/auth query/header
- username/email
- full server URL if it may identify a private host
- song/album/artist titles
- lyrics
- local file paths containing personal names

User-visible preview/redaction is preferred before sharing.
