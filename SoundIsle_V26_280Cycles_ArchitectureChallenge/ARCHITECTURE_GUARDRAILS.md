# SoundIsle Architecture Guardrails

## Singleton/Core Ownership
There must be exactly one application-owned:
- PlayerStateStore
- QueueManager
- active PlayerController
- Database facade
- SecureStorage facade

Do not introduce parallel substitutes such as `NewPlayerManager`, `MusicStateStore2`, or page-owned player services.

## Contract Change
Changing a public internal contract requires:
1. updating interface;
2. updating all callers;
3. updating tests;
4. updating relevant normative docs;
5. ADR if behavior/architecture materially changes.

## Change Budget
A task may refactor only what is required for correctness/maintainability of that task.
Large unrelated refactors require explicit ADR or milestone approval.

## Compatibility Workarounds
Provider/version special cases belong in one compatibility location with:
- affected version
- reason
- verification evidence
- regression test
- removal condition

No scattered `if (serverName == ...)` logic across UI/player.
