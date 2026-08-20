# SoundIsle Retry / Idempotency Matrix

## Classes

### SAFE_READ
Examples: ping, getAlbum, search, artwork metadata.
Bounded retry allowed.

### STREAM_RECOVERY
Playback stream/source refresh.
Retry is state-aware, generation-guarded and bounded.

### IDEMPOTENT_WRITE
Only when provider operation is known idempotent or request identity makes replay safe.
Bounded retry may be allowed.

### NON_IDEMPOTENT_WRITE
Examples may include create-like operations where replay can duplicate state.
Do not blind retry after an ambiguous timeout.

### LOCAL_DURABLE_WRITE
Use transaction/atomic semantics as appropriate. Failure is surfaced; never silently discard user intent.

## Rule
Every remote mutation must be classified before implementation. “Network error → retry” is not an acceptable generic policy.
