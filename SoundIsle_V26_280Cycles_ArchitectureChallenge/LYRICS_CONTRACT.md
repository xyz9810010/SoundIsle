# SoundIsle Lyrics Contract

Domain timing uses integer milliseconds.

Supported domain forms:
- plain text
- line-synced
- structured/word-synced only when provider evidence supports it

Provider mapper must:
- convert source time units to ms;
- validate negative/overflow timestamps;
- handle duplicate timestamps deterministically;
- reject or normalize impossible descending timelines;
- preserve Unicode text;
- never expose provider DTOs directly to UI.

Lyrics failure never blocks audio playback.
