# SoundIsle Document Precedence

This file exists to prevent AI agents from obeying two conflicting documents at once.

## Precedence
1. Latest explicit user requirement
2. Security, privacy, data integrity, and actual HarmonyOS SDK/platform constraints
3. `MASTER_PLAN.md`
4. Accepted ADRs
5. `CURRENT_MILESTONE.md`
6. `ACCEPTANCE_CRITERIA.md`
7. Architecture/API/audio specs
8. Data/schema/error/UI/security/download/cache/settings specs
9. `TASKS.md`
10. Implementation preference

## Conflict Rule
If a conflict is discovered:
1. do not silently choose whichever text is convenient;
2. identify the conflicting clauses;
3. prefer the higher-precedence source;
4. create/update an ADR if the conflict is architectural;
5. update stale documents in the same change;
6. record the resolution in `PROJECT_STATUS.md`.

## Status Vocabulary
`NOT_STARTED → READY → IN_PROGRESS → IMPLEMENTED → AUTO_TESTED → INTEGRATION_TESTED → DEVICE_TEST_REQUIRED → DEVICE_TESTED → USER_ACCEPTED → DONE`

No AI may skip a state that is required by the feature's acceptance criteria.
