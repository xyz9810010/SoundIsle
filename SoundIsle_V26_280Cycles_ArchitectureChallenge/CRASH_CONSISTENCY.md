# SoundIsle Crash Consistency

## Playback/Queue Snapshot
Persist logically-related snapshot state transactionally or via atomic replacement with:
- schema version
- snapshot generation/version
- validation on restore

Never reconstruct a trusted snapshot from a partially-written set of unrelated preference keys.

## Download Commit
Commit order:
1. write temporary owned file;
2. finish stream;
3. validate required integrity/size metadata when available;
4. atomically rename/move to final path where platform supports it;
5. only then persist `COMPLETED`.

Startup reconciliation repairs safe mismatches; it never labels partial temp files as complete.
