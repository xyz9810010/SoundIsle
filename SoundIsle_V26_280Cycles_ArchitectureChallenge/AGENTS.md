# SoundIsle AI Agent Operating Rules

## Start Order
1. `START_HERE.md`
2. `CURRENT_MILESTONE.md`
3. `TASKS.md`
4. `TASK_SPEC_MAPPING.md`
5. load only the current task's `required_docs`
6. `PROJECT_STATUS.md`

Do not load `docs/archive/*` unless investigating historical rationale.

## Execution Loop
```text
select first READY task
→ inspect relevant specs/code
→ implement smallest complete change
→ compile
→ run applicable tests
→ fix failures
→ update evidence/status
→ commit when appropriate
→ continue
```

Do not stop just because one task completed while executable tasks remain.

## Do Not Invent Platform Facts
When a HarmonyOS/OpenSubsonic API is uncertain:
- inspect the actual SDK/docs/source available to the environment;
- record unresolved assumptions;
- never create imaginary APIs to make code compile conceptually.

## No False Completion
- source code written ≠ tested
- AUTO_TESTED ≠ DEVICE_TESTED
- IMPLEMENTED_UNVERIFIED ≠ First-Class Provider
- a UI switch ≠ correctly implemented audio feature

## Ask User Only When Necessary
Ask only for irreducible external inputs such as real credentials, signing account, physical-device-only action, or a product decision genuinely not covered by precedence/specs.

## Scope
`DEFER` and `REJECT` items are not to be implemented opportunistically.
M0 cannot absorb M2/M3/P2 feature work merely because it is convenient.


## V13 Required Reads by Task Type
- Provider work → `PROVIDER_CONTRACT.md`
- Download work → `DOWNLOAD_ARCHITECTURE.md`
- Storage/cache work → `CACHE_POLICY.md`, `DATABASE_SCHEMA.md`
- Migration work → `MIGRATION_STRATEGY.md`
- Security-sensitive work → `SECURITY.md`
- Release work → `RELEASE_GATES.md`

- Queue work → `QUEUE_SEMANTICS.md`
- History/scrobble work → `HISTORY_SCROBBLE_POLICY.md`
- Network resume/expiry work → `NETWORK_EDGE_CASES.md`

Never translate Android/iOS APIs into HarmonyOS by name/analogy without checking the actual HarmonyOS SDK.

Do not read review archives as normative specifications. Use DOC_INDEX tiers. Do not introduce cross-platform abstraction or dynamic provider plugin systems unless a future milestone explicitly requires them.

- Lifecycle/server removal → `LIFECYCLE_POLICY.md`
- Large-library/performance/soak → `PERFORMANCE_BUDGET.md`
- Cleanup/retention → `RETENTION_POLICY.md`
- Backup/restore → `BACKUP_FORMAT.md`
- Capability refresh → `CAPABILITY_LIFECYCLE.md`

- Architecture/core refactor → `ARCHITECTURE_GUARDRAILS.md`
- Remote input/resource limit work → `RESOURCE_LIMITS.md`
- Dependency changes → `DEPENDENCY_POLICY.md`
- Release configuration → `RELEASE_CONFIGURATION.md`
- Adversarial testing → `CHAOS_TEST_PLAN.md`

Never create a second core state/store/manager when an existing normative core already owns that responsibility.

- All review/change proposals → `REVIEW_EVIDENCE_POLICY.md`
- Task preparation → `TASK_SPEC_MAPPING.md`

After V18, do not change stable architecture merely because another approach is possible. A change requires a demonstrated defect or measurable benefit that outweighs migration risk.

- Any playback/queue/download/migration work → `SYSTEM_INVARIANTS.md`
- Remote mutation/retry work → `RETRY_IDEMPOTENCY_MATRIX.md`
- Recovery logic → `RECOVERY_BUDGET.md`
- State-heavy testing → `PROPERTY_TEST_SPEC.md`

When implementation choices differ, prefer the design that makes invariants easier to prove and test.

- Cross-layer/module work → `MODULE_CONTRACTS.md`, `DEPENDENCY_DAG.md`
- ArkTS types/DTOs → `TYPE_SYSTEM_RULES.md`
- Persistence models → `PERSISTENCE_CONTRACT.md`
- Error propagation → `ERROR_CONTRACTS.md`
- File/package naming → `NAMING_LAYOUT_RULES.md`

Do not solve type errors by weakening types to `any` or bypassing mapping/validation.

## Documentation Cost Rule
Do not read all specifications by default. Use `TASK_SPEC_MAPPING.md`.
When a rule is duplicated, prefer the primary source in `SPEC_OWNERSHIP.md`.

## M0/M1 Implementation Simulation Rules
Before M0/M1 work read `AI_IMPLEMENTATION_FAILURES.md`.
M0 work must obey `IMPLEMENTATION_BLUEPRINT.md`.
Server setup work must obey `SERVER_CONNECTION_FLOW.md` and `URL_CONSTRUCTION.md`.
Large list work must obey `PAGINATION_CONTRACT.md`.

## Pull Request Discipline
Before claiming a code slice ready, self-review against `PR_REVIEW_CHECKLIST.md`.
Use `PR_TEMPLATE.md` as the evidence structure.
Playback changes must additionally use `PLAYBACK_IMPLEMENTATION_CHECKLIST.md`.

## Cross-Milestone Discipline
Before moving to a new milestone, run `TECH_DEBT_GATE.md`.
Persisted-data changes require `UPGRADE_COMPATIBILITY.md`.
Background/media-session work requires real-device evidence per `DEVICE_LIFECYCLE_TEST_MATRIX.md`.
Never claim exact HarmonyOS background/media APIs without verifying the repository SDK/toolchain.

## Production Reality
Treat server responses, media metadata, proxy behavior and persisted old-version data as untrusted inputs.
Do not claim compatibility from one Navidrome instance. Update `PRODUCTION_COMPAT_MATRIX.md` with evidence.
Never solve self-signed TLS by disabling certificate validation globally.

## Minimal Complexity
Use `ACTIVE_SPEC_SET.md` and `TASK_RISK_LEVELS.md`; do not load the entire corpus by default.
Before adding an abstraction, apply `ABSTRACTION_RULES.md`.
Before adding V1 infrastructure, justify it against `MVP_COMPLEXITY_BUDGET.md`.
Do not create future-provider APIs without a committed requirement.
