# SoundIsle Network Timeout Policy

Do not use one global timeout for every operation.

Classify operations:
- connection/auth probe
- interactive metadata request
- artwork/lyrics request
- source resolution
- long-lived audio stream
- background download

Each class may have distinct connect/read/overall timeout and retry semantics.

Long-lived streaming is not treated like a short JSON request. Timeout changes must remain compatible with RETRY_IDEMPOTENCY_MATRIX and RECOVERY_BUDGET.
