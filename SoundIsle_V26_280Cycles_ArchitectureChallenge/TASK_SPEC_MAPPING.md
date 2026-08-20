# SoundIsle Task → Required Specs Mapping

Every task must declare `required_docs`. `START_HERE.md` is read first; only task-specific specs are loaded after that.

Every task should declare `required_docs`.

## Examples
- playback/core → MASTER_PLAN, ARCHITECTURE, AUDIO_ARCHITECTURE, PLAYBACK_STATE_MACHINE, QUEUE_SEMANTICS
- provider/OpenSubsonic → PROVIDER_CONTRACT, API_OPEN_SUBSONIC, ERROR_MODEL, NETWORK_EDGE_CASES
- download → DOWNLOAD_ARCHITECTURE, CACHE_POLICY, DATABASE_SCHEMA, DATA_RECOVERY
- DB/migration → DATABASE_SCHEMA, MIGRATION_STRATEGY, DATA_RECOVERY
- UI/player → UI_SPEC, I18N_ACCESSIBILITY, ACCEPTANCE_CRITERIA
- security/network → SECURITY, RESOURCE_LIMITS, NETWORK_EDGE_CASES
- release → RELEASE_GATES, RELEASE_CONFIGURATION, FEATURE_GATES
- lifecycle/backup → LIFECYCLE_POLICY, RETENTION_POLICY, BACKUP_FORMAT

A task must not claim DONE if a required normative spec was not considered.

- any cross-module refactor → MODULE_CONTRACTS, DEPENDENCY_DAG, ARCHITECTURE_GUARDRAILS
- DTO/model work → TYPE_SYSTEM_RULES, DATA_MODEL
- persistence work → PERSISTENCE_CONTRACT, DATABASE_SCHEMA, MIGRATION_STRATEGY
- error handling → ERROR_CONTRACTS, ERROR_MODEL
- package/layout changes → NAMING_LAYOUT_RULES
- M0 skeleton → IMPLEMENTATION_BLUEPRINT, COMPOSITION_ROOT_SPEC, ARCHITECTURE, MODULE_CONTRACTS
- server add/edit → SERVER_CONNECTION_FLOW, SECURITY, DATA_MODEL
- server URL handling → URL_CONSTRUCTION, NETWORK_EDGE_CASES
- large read APIs → PAGINATION_CONTRACT
- M0/M1 acceptance → M0_M1_ACCEPTANCE

- any PR review → PR_REVIEW_CHECKLIST
- M2 playback PR → PLAYBACK_IMPLEMENTATION_CHECKLIST, SYSTEM_INVARIANTS, PLAYBACK_STATE_MACHINE
- ViewModel/UI async state → PRESENTATION_STATE_POLICY
- download scheduler → DOWNLOAD_SCHEDULER_POLICY
- user-facing errors → ERROR_PRESENTATION_POLICY
- credential/profile persistence → CREDENTIAL_COMPENSATION

- milestone exit → TECH_DEBT_GATE, PROJECT_STATUS, RISK_REGISTER
- persisted format upgrade → UPGRADE_COMPATIBILITY, MIGRATION_STRATEGY, DATA_RECOVERY
- app/background playback lifecycle → APP_LIFECYCLE_PLAYBACK, BACKGROUND_MEDIA_REQUIREMENTS
- playback + downloads/network contention → NETWORK_QOS_POLICY, DOWNLOAD_SCHEDULER_POLICY
- real device lifecycle → DEVICE_LIFECYCLE_TEST_MATRIX
- storage-full behavior → STORAGE_EXHAUSTION_POLICY

- production compatibility → PRODUCTION_COMPAT_MATRIX
- malformed/edge media → MEDIA_ROBUSTNESS_POLICY, RESOURCE_LIMITS
- crash-safe queue/download persistence → CRASH_CONSISTENCY
- support diagnostics → DIAGNOSTIC_BUNDLE, SECURITY
- compatibility feature disable → COMPATIBILITY_KILL_SWITCH, FEATURE_GATES
- network timeouts → NETWORK_TIMEOUT_POLICY, RETRY_IDEMPOTENCY_MATRIX

- task planning → TASK_RISK_LEVELS, ACTIVE_SPEC_SET
- new abstraction/interface → ABSTRACTION_RULES
- MVP scope/infra addition → MVP_COMPLEXITY_BUDGET
- architecture decision record → ADR_POLICY
- test doubles → TEST_DOUBLE_POLICY
