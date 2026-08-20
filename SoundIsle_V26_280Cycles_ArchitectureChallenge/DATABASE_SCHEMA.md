# SoundIsle Local Database Schema

This is a logical schema. Exact ArkData/RDB SQL must be generated from the real HarmonyOS SDK used by the project.

## Schema Version
Start at `1`. Every public/beta release increments schema only through explicit migrations.

## Tables

### servers
- id TEXT PRIMARY KEY
- name TEXT NOT NULL
- provider_type TEXT NOT NULL
- primary_url TEXT NOT NULL
- lan_url TEXT NULL
- alternative_urls_json TEXT NOT NULL
- username TEXT NULL
- credential_ref TEXT NOT NULL
- enabled INTEGER NOT NULL
- created_at_ms INTEGER NOT NULL
- updated_at_ms INTEGER NOT NULL

### play_history
- id TEXT PRIMARY KEY
- provider_id TEXT NOT NULL
- server_id TEXT NOT NULL
- remote_song_id TEXT NOT NULL
- title_snapshot TEXT NOT NULL
- artist_snapshot TEXT NOT NULL
- started_at_ms INTEGER NOT NULL
- listened_ms INTEGER NOT NULL
- last_position_ms INTEGER NOT NULL
- completed INTEGER NOT NULL

Index: `(server_id, remote_song_id)`, `started_at_ms DESC`.

### local_favorites
Composite identity:
- provider_id
- server_id
- media_type
- remote_id
- created_at_ms
- server_sync_state

Primary key: all identity columns.

### local_playlists
- id TEXT PRIMARY KEY
- name TEXT NOT NULL
- created_at_ms
- updated_at_ms

### local_playlist_items
- playlist_id
- position INTEGER
- provider_id
- server_id
- media_type
- remote_id
- title_snapshot
- artist_snapshot
- album_snapshot
Primary key: `(playlist_id, position)`.
Index media identity for lookup.

### queue_snapshot
Single logical row:
- queue_version INTEGER
- current_index INTEGER
- current_position_ms INTEGER
- play_mode TEXT
- user_playback_intent TEXT
- origin_json TEXT
- updated_at_ms INTEGER

### queue_items
- queue_version INTEGER
- position INTEGER
- media identity fields
- display snapshots
Primary key `(queue_version, position)`.

### downloads
- id TEXT PRIMARY KEY
- media identity fields
- file_path TEXT NOT NULL
- state TEXT NOT NULL
- quality_policy TEXT
- source_type TEXT
- expected_size_bytes INTEGER NULL
- actual_size_bytes INTEGER NULL
- checksum TEXT NULL
- created_at_ms
- completed_at_ms NULL
- error_code TEXT NULL

### search_history
- id TEXT PRIMARY KEY
- query TEXT NOT NULL
- created_at_ms NOT NULL
Unique normalized query recommended.

### settings_meta
Only for structured settings not suitable for Preferences. Most ordinary settings stay in Preferences.

### cache_index
- cache_key TEXT PRIMARY KEY
- cache_type TEXT
- path TEXT
- size_bytes INTEGER
- expires_at_ms INTEGER NULL
- last_access_ms INTEGER

## Credentials
Passwords, API Keys, tokens, sensitive headers and private key material are **not columns in this database**. Only a secure-store reference is persisted.

## Migrations
Every migration must be:
- deterministic;
- covered by automated migration tests;
- non-destructive for durable user state;
- safe to retry or fail cleanly;
- documented in CHANGELOG/ADR when behavior changes.

Never recover from a migration failure by silently dropping all user tables.

## Deletion Semantics
- Clear Cache → deletes cache index/files only.
- Delete Download → deletes selected offline asset, never server content.
- Remove Server → deletes credentials and remote cache; durable local favorites/playlists/history/downloads require explicit policy and must not be silently erased.
