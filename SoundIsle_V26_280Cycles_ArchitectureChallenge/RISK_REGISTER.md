# SoundIsle Risk Register

| ID | Risk | Impact | Response |
|---|---|---|---|
| R1 | HarmonyOS background playback differs from assumptions | High | Real-device gate in M3 |
| R2 | AVPlayer format/server behavior varies | High | Format matrix + real Navidrome tests |
| R3 | Async playback race causes wrong song/state | Critical | Generation, cancellation, serialized engine commands |
| R4 | Network/route switching causes interruptions | High | Recovery policy; no rebuild on NetworkChanged alone |
| R5 | Cache/download boundary deletes user assets | Critical | Separate storage semantics + stop-ship tests |
| R6 | Upgrade migration loses local user state | Critical | Migration tests + backup/rollback strategy |
| R7 | Gapless promise exceeds platform capability | Medium | VERIFY before claim |
| R8 | 50k+ library hurts performance | High | API-first pagination/lazy rendering/perf tests |
| R9 | Credentials leak in logs/redirects | Critical | Secure storage, redaction, redirect auth policy |
| R10 | Scope expansion blocks Navidrome V1 | High | Navidrome First-Class; other providers cannot block release |

| R11 | AI agents interpret conflicting documents differently | High | DOCUMENT_PRECEDENCE + ADR + acceptance IDs |
| R12 | Domain units/identity mismatch causes subtle bugs | High | DATA_MODEL invariants + tests |
| R13 | Error retry duplicates writes | High | ERROR_MODEL retry matrix + idempotency |
| R14 | UI semantics drift across pages | Medium | UI_SPEC + acceptance criteria |

| R15 | Download state/file diverge after crash | Critical | temp/final separation + restart reconciliation |
| R16 | Cache eviction races active playback | High | pin active entries + cache policy |
| R17 | Remote metadata triggers path/memory abuse | High | sanitization + limits + fuzz tests |
| R18 | Server removal creates orphan local records | Medium | orphan semantics + snapshots |
| R19 | Settings defaults drift between pages | Medium | centralized SETTINGS_MODEL |
| R20 | Multi-agent doc drift | High | precedence + ADR + required spec sync |

| R21 | Provider DTO leaks into UI/domain and couples protocol to product | High | MODULE_CONTRACTS + mapping tests |
| R22 | `any`/unchecked casts hide remote-data defects | High | TYPE_SYSTEM_RULES + lint/review |
| R23 | Cross-layer circular dependency grows over time | High | DEPENDENCY_DAG + architecture tests |
| R24 | Domain evolution silently breaks persistence | Critical | PERSISTENCE_CONTRACT + migrations |
| R25 | Raw platform errors leak into UI | Medium | ERROR_CONTRACTS |
