# SoundIsle Feature Gates

States:
`DISABLED | INTERNAL | BETA | ENABLED`

Rules:
- Unverified features default DISABLED or INTERNAL.
- A UI entry must not imply a feature works merely because code exists.
- Gapless, ReplayGain, Beta providers and experimental recovery paths require explicit gates until their acceptance evidence exists.
- Gate defaults are centralized and release-reviewed.
- Removing a gate requires acceptance evidence and PROJECT_STATUS update.

## Release Authority
`DISABLED` and `INTERNAL` release gates are controlled by build/product policy and cannot be enabled by ordinary user settings or stale persisted preferences.

## Effective Gate
Conceptually:
`effective = releaseAllows && runtimeCapabilityAllows && userSettingAllows`

For features without a user toggle, omit that factor. A false higher-level factor cannot be overridden by user preferences.

## Complexity Rule
Do not create a gate for every small feature. Gates are for incomplete/risky/release-controlled capabilities or meaningful staged behavior.
