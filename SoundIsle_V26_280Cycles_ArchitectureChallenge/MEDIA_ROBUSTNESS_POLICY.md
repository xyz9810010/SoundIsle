# SoundIsle Media Robustness Policy

Remote metadata is untrusted input.

Validate or bound:
- duration
- bitrate/sample-rate/channel metadata
- artwork dimensions/decoded pixel budget
- lyrics size/line count/timestamps
- playlist/queue item counts
- string lengths where rendering/storage risk exists

Playback:
- file extension does not prove decodability;
- platform decode failure becomes a stable playback error;
- policy may attempt server transcoding when supported;
- one bad item must not corrupt queue state.

Unknown/zero duration must not create fake seekability.
