# SoundIsle Download Architecture

## State Machine
`QUEUED → RUNNING → VERIFYING → COMPLETED`

Side states:
`PAUSED | FAILED | CANCELED`

## Rules
- Download writes to a temporary path first.
- Only VERIFIED content moves to final download storage.
- A database row marked COMPLETED must correspond to an existing final file.
- Resume uses HTTP Range only when server support and response semantics are verified.
- If resume is unsupported or unsafe, restart cleanly.
- Download retries are bounded.
- App restart reconstructs queued/running/paused tasks from durable state.
- Cache cleanup never touches final download storage.

## Concurrency
Default concurrency is conservative and configurable.
Priority:
1. user-initiated current download
2. active album/playlist batch
3. background low-priority work

## Storage Full
- pause/fail the affected task;
- provide a clear error;
- never delete previous downloads automatically.

## Delete Semantics
Deleting a download removes only the local offline asset and associated download record. It never deletes remote server content.


## Storage Exhaustion
Follow `STORAGE_EXHAUSTION_POLICY.md`; preflight free-space checks never justify marking a partial write successful.
