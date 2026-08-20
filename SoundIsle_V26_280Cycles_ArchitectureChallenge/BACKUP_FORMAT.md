# SoundIsle Backup / Restore Contract

Use a logical versioned backup, not a raw database copy.

```text
{
  format: "soundisle-backup",
  schemaVersion: integer,
  appVersion: string,
  exportedAtEpochMs: integer,
  data: { ... }
}
```

Include non-secret server profiles, settings, favorites, playlists/items, optional history and orphan snapshots.

Exclude by default passwords/tokens/API keys, logs, cache and downloaded audio binaries.

Restore validates versions, handles conflicts, avoids silent overwrite and requires credentials to be re-entered unless a future secure platform migration mechanism is explicitly implemented.

## Restore Conflict Strategy
When imported data conflicts with existing durable data, supported strategies are:
- MERGE
- KEEP_BOTH
- REPLACE

Default restore must never silently overwrite existing unrelated user data. The chosen policy must be explicit at restore time or defined by a documented safe default.
