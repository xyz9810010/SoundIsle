# SoundIsle Settings Model

Each setting defines:
`key | type | scope | default | migration | UI label`

## Scopes
- GLOBAL
- SERVER
- NETWORK_TYPE
- DEVELOPER

## Core Defaults
- theme: FOLLOW_SYSTEM
- restartAutoPlay: false
- wifiQuality: ORIGINAL
- mobileQuality: AUTO_HIGH
- downloadQuality: ORIGINAL
- downloadOverMobile: false
- clearCacheDeletesDownloads: impossible by design
- diagnosticsUpload: false
- favoriteServerSync: false
- gapless: feature-gated until verified
- replayGain: unavailable until verified

## Rules
- Defaults are centralized, not duplicated across pages.
- Unknown old keys are migrated or safely ignored.
- Changing server-specific settings never mutates another server profile.

## V1 Surface Rule
Expose only settings with stable, understandable user behavior. Internal recovery/QoS/provider tuning is not automatically a user setting.
