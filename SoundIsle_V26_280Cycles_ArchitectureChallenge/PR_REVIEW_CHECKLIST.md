# SoundIsle Pull Request Review Checklist

## Scope
- PR is one reviewable vertical slice.
- No unrelated refactor.
- `required_docs` are declared.
- Behavior/architecture changes update the correct normative spec/ADR.

## Architecture
- no second core store/manager;
- no page-created Repository/Provider/AVPlayer;
- dependency DAG remains acyclic;
- DTO/Persistence/Domain boundaries are preserved.

## State & Concurrency
- async callbacks are stale-safe;
- request/playback generations are checked at commit points;
- one Presentation State authority per feature;
- cancellation/disposal is handled.

## Security
- no credentials in code, RDB, Preferences, logs or diagnostics;
- sensitive headers/query parameters are redacted;
- cross-host redirects do not forward auth unexpectedly.

## Behavior
- user PAUSE wins;
- route loss behavior is safe;
- queue invariants hold;
- errors are actionable and not spammed.

## Tests
At least one test must assert externally meaningful behavior/state, not merely that a mock method was invoked.

## Evidence
Reviewer should be able to identify:
- build/test command used;
- automated result;
- device test status if required;
- screenshots/log summary only when relevant and redacted.
