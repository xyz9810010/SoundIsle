# SoundIsle Migration Strategy

## Goals
Preserve durable user state across upgrades and fail safely.

## Required Properties
- explicit source schema version
- explicit target schema version
- migration runs transactionally where platform support permits
- failure never silently drops durable tables
- post-migration validation runs before marking schema current

## Validation
Compare critical record counts/keys for:
- servers
- local favorites
- local playlists/items
- history
- downloads
- queue snapshot

## Failure
On failure:
- retain old data;
- surface a recoverable application error;
- write sanitized diagnostic information;
- do not continue using a partially migrated schema as if valid.

## Public/Beta Releases
Every release with schema changes must include migration tests from the immediately previous public/beta schema.

## Idempotent/Resumable Migration Steps
Each migration step must detect whether it is already applied before destructive alteration where practical. After migration, validate the target schema/version before committing the new current-version marker.
