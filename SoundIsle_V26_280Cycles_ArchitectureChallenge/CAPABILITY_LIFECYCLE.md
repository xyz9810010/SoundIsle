# SoundIsle Provider Capability Lifecycle

Capability snapshots record server/profile id, exposed server/protocol version, extensions/capabilities and observed time.

Refresh on first connection, explicit reconnect/test, meaningful server version change, or capability-dependent failure suggesting stale information.

Capabilities guide optional UI/behavior but do not replace defensive runtime fallback.
