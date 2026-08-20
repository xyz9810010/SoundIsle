# SoundIsle Glossary

- **MediaKey**: stable namespaced remote-media identity: provider + server + type + remote id.
- **AudioSource**: actual playable source for current playback, including route/source type/technical audio info.
- **QueueSeed**: ordered queue items + current index + origin used to initialize queue context.
- **PlaybackOrigin**: where a queue came from, e.g. album/playlist/search/single.
- **UserPlaybackIntent**: user's desired high-level state, PLAY or PAUSE.
- **PlaybackGeneration**: monotonically changing identity for a user media-selection generation; stale async work may not commit.
- **PlaybackInhibitor**: temporary condition blocking effective playback despite user intent.
- **PlayerStateStore**: application-level playback state authority.
- **QueueManager**: application-level real-time queue authority.
- **PlaybackResolver**: resolves MediaKey + policy + route into AudioSource.
- **PlaybackEngine**: platform-facing audio execution abstraction; first HarmonyOS implementation uses AVPlayer.
- **Provider**: adapter for a remote music-server protocol.
- **First-Class Provider**: provider verified to release quality for the declared feature scope.
- **Durable User Data**: favorites/playlists/settings/download records and other user-owned state that may not be silently discarded.
- **Cache**: disposable data that may be re-fetched or safely degraded.
