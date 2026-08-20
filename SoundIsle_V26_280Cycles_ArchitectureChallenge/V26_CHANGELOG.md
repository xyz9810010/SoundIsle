# V26 Changelog — 280 Cumulative Cycles

Focus: attempt to disprove the architecture and remove unjustified complexity.

Added:
- MVP_COMPLEXITY_BUDGET.md
- ABSTRACTION_RULES.md
- ACTIVE_SPEC_SET.md
- TASK_RISK_LEVELS.md
- ADR_POLICY.md
- TEST_DOUBLE_POLICY.md

Decisions:
- Repository retained, but no mechanical repository proliferation
- PlayerStateStore retained, but must not become global AppStore
- Provider abstraction retained only as a minimal current protocol boundary
- speculative future-provider APIs prohibited
- advanced features cannot block V1 core journey
- interface/mapper/ADR/gate creation now has explicit complexity thresholds
- documentation burden scales with task risk

Verdict: V26 / 280 cycles converged.
