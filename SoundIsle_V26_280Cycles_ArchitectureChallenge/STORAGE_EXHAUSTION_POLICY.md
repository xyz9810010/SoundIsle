# SoundIsle Storage Exhaustion Policy

Free-space precheck is advisory, not proof.

During file/cache/download writes:
- handle out-of-space failure;
- never mark incomplete file COMPLETED;
- keep durable download state recoverable;
- clean owned temp file when safe;
- do not delete unrelated user data automatically;
- surface actionable storage error.

Cache eviction may run according to CACHE_POLICY but must not delete durable downloads merely to hide ENOSPC.
