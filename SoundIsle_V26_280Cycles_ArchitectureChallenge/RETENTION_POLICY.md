# SoundIsle Retention Policy

Durable favorites, playlists, downloads, server profiles and settings do not auto-expire.

Playback history is durable with explicit user clear/retention behavior. Search history is separately bounded. Logs are rotated/bounded. Cache follows CACHE_POLICY and may be evicted subject to active pinning.

Removing a server deletes credentials and disposable cache; durable local records require explicit policy.
