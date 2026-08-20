# SoundIsle Milestone Technical-Debt Gate

At the end of every milestone classify known debt:

- P0 — correctness/data-loss/security blocker
- P1 — high-risk architecture/playback/release debt
- P2 — important but safely deferrable
- P3 — cleanup/optimization

Rules:
- P0/P1 cannot silently roll into the next milestone.
- If intentionally deferred, the milestone is not considered fully closed unless an explicit approved exception exists.
- Debt must name owner area, concrete risk, evidence, and target milestone.
- “Temporary” architecture must have an expiry condition.

A milestone review checks:
1. API/contracts stable enough for next milestone;
2. no known plaintext secret/data-loss path;
3. migration path exists for already-persisted data;
4. next milestone does not require bypassing current boundaries;
5. device-only unknowns are explicitly DEVICE_TEST_REQUIRED.
