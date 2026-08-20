# SoundIsle Product Requirements

## Product North Star
让拥有自己音乐服务器的人，在 HarmonyOS 上以最少配置、最稳定的方式听自己的音乐；普通用户觉得简单，重度用户觉得高效，发烧友能看到真实音频能力，自托管用户拥有足够控制权。

## V1 Golden User
HarmonyOS user + existing Navidrome server + wants a reliable native player.

## Golden Path
```text
Open SoundIsle
→ choose Navidrome
→ server address
→ username/password
→ connect
→ see library
→ tap song
→ hear audio
```

No API/version/codec/transcode configuration is required on the golden path.

## P0 Experience
- reliable playback
- queue
- seek
- background/lock-screen controls
- Bluetooth/media controls
- understandable errors
- local favorites/history
- downloads/offline
- persistent queue
- local user data never silently lost

## UX Principle
Simple by default, powerful when expanded.

## V1 Scope
First-Class: Navidrome/OpenSubsonic.
Other providers may exist as BETA/IMPLEMENTED_UNVERIFIED and must not block V1.
