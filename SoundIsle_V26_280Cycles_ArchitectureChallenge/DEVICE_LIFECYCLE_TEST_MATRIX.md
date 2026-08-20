# SoundIsle Device Lifecycle Test Matrix

Run on real HarmonyOS device where applicable.

Scenarios:
- screen off/on during playback
- app foreground/background
- page navigation away/back
- app process killed then reopened
- Wi-Fi → cellular / cellular → Wi-Fi
- temporary network loss/recovery
- wired/headphone/Bluetooth disconnect
- Bluetooth reconnect after safe pause
- incoming call/audio interruption
- lock-screen play/pause/next/previous/seek
- system media card metadata update
- low-power/background restrictions
- download while playing
- storage fills during download

For each record:
- expected PlayerState
- UserPlaybackIntent
- audible/not audible
- currentMediaKey
- position behavior
- queue preservation
- recovery attempt/result
- device/OS build
