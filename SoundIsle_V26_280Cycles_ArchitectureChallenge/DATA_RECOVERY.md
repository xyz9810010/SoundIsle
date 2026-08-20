# SoundIsle Data Recovery

## Principle
Database failure is not permission to erase user data.

## Startup Failure
If durable storage cannot open/migrate:
1. stop writes to affected storage;
2. preserve files/database;
3. expose a recoverable diagnostic state;
4. offer supported recovery/export paths when implemented;
5. never silently recreate an empty DB over the old one.

## Backup Format
Future export/import carries:
`schemaVersion, appVersion, exportedAt, servers(non-secret), settings, favorites, playlists, history(optional)`.

Credentials are excluded by default. Downloaded media is not required inside configuration backups.

## Reconciliation
Downloads/cache are reconciled against the filesystem after abnormal termination. Durable metadata must not be deleted solely because a remote server is temporarily unavailable.
