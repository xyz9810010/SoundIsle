# SoundIsle UI / UX Specification

## Navigation
Primary mobile navigation:
`首页 | 音乐库 | 搜索 | 我的`

Mini Player sits above bottom navigation whenever a queue/current media exists.

## First Launch
```text
欢迎
→ Navidrome
→ 服务器地址
→ 用户名
→ 密码
→ 连接
→ 成功后直接进入首页
```
No API version/codec/transcode screens in the normal onboarding path.

## Required Page States
Every remote-content page supports:
`Loading | Content | Empty | Refreshing | OfflineWithCache | OfflineNoCache | PartialError | FatalError`

## Home
Priority:
1. Continue Listening
2. Recently Played
3. Recently Added
4. Favorites
5. Frequently Played / server-supported discovery

Technical server status never dominates the first screen.

## Library
Tabs/sections:
`歌曲 | 专辑 | 艺术家 | 歌单 | 类型 | 已下载`

## Search
Single tap on a song plays that song only.
Explicit `播放全部` builds a queue from currently loaded results.
Search query/result state survives detail navigation.

## Player
Core controls remain visible:
- cover
- title / artist
- progress
- previous / play-pause / next
- play mode
- favorite
- queue
- lyrics

Advanced audio info is secondary.

## Audio Labels
Normal UI: `原始音质 / 高音质 / 标准 / 省流量`
Advanced detail may show actual codec/bitrate/sample rate/bit depth/source type.
Never infer “Lossless” solely from the server file extension.

## Favorites
One visible favorite action.
Local favorite commits immediately. Optional server sync happens in the background and may expose sync status in details.

## Downloads
Clear text:
`清除缓存不会删除你主动下载的音乐。`
Delete download:
`只删除手机上的离线文件，不会删除服务器歌曲。`

## Accessibility
- semantic labels for controls
- large text support
- no color-only state
- adequate touch targets
- screen reader exposes play/pause/favorite/download states

## Responsive
Phone: bottom navigation, single column.
Large-screen/foldable/tablet: navigation rail/two-pane where useful; do not simply stretch phone UI.

## Design Tokens
Before visual implementation, define tokens for:
`Color, Typography, Spacing, Radius, Elevation, IconSize, TouchTarget, Motion`

No arbitrary per-page spacing/color constants.
