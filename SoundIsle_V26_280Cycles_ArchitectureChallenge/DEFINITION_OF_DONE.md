# SoundIsle Definition of Done

A task is DONE only when all applicable items pass:

1. implementation exists and compiles;
2. required_docs were read and remain consistent;
3. acceptance criteria for the task are satisfied;
4. applicable unit/contract/integration tests pass;
5. system invariants are not violated;
6. no new P0/P1 defect is introduced;
7. migration/security/release implications are handled when relevant;
8. PROJECT_STATUS and task evidence are updated;
9. documentation/ADR is updated if behavior or architecture changed;
10. device-only capability is not marked DONE until DEVICE_TESTED.

`IMPLEMENTED`, `AUTO_TESTED`, and `DEVICE_TEST_REQUIRED` are not synonyms for DONE.
