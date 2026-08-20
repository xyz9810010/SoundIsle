# SoundIsle Upgrade Compatibility

## Database
Never automatically wipe user data because a migration fails.

Migration failure:
- preserve original durable data where practical;
- stop unsafe writes;
- expose diagnosable recovery state;
- allow retry/repair/backup path according to DATA_RECOVERY.

## Persisted Snapshots
Version Queue/Playback/backup blobs.

On read:
`version → migrate → validate → Domain`

Unknown future versions are not parsed as if current.

## Settings
Persisted enums/settings require:
- known-value parsing;
- safe default for unknown/deprecated values;
- explicit migration when semantics changed.

## Credentials
Changing credential storage format requires staged migration. Never log old/new secret values during migration.
