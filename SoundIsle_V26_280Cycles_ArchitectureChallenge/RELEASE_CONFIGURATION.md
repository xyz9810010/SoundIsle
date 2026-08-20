# SoundIsle Release Configuration

## Release Must Differ Safely From Debug
Verify:
- package/app id
- signing configuration
- permissions
- background audio declarations
- feature gate defaults
- logging level
- test endpoints/credentials absent
- diagnostic developer options disabled or hidden appropriately

## Critical Path
At least one RC/Release build must run:
connect real Navidrome → browse → play → background → lock screen → Bluetooth/system controls → download/offline.

Debug-only success is insufficient.
