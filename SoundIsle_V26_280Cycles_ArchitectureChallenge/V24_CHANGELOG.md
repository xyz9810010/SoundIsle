# V24 Changelog — 240 Cumulative Cycles

Focus: simulate continuous M0→M3 development and find debt that explodes in later milestones.

Added:
- TECH_DEBT_GATE.md
- UPGRADE_COMPATIBILITY.md
- APP_LIFECYCLE_PLAYBACK.md
- BACKGROUND_MEDIA_REQUIREMENTS.md
- NETWORK_QOS_POLICY.md
- DEVICE_LIFECYCLE_TEST_MATRIX.md
- STORAGE_EXHAUSTION_POLICY.md

Key decisions:
- P0/P1 debt cannot silently roll forward
- migration failure never auto-wipes durable user data
- Page lifecycle is not playback lifecycle
- external/system media commands share PlayerController
- background/media-session APIs require real SDK/device verification
- playback network traffic outranks background downloads
- Bluetooth reconnect does not auto-resume by default
- storage precheck does not replace runtime ENOSPC handling

Verdict: V24 / 240 cycles converged.
