# SoundIsle MVP Complexity Budget

V1 optimizes for a reliable core journey:
`Add Server → Browse/Search → Play → Queue → Background/Lock-screen basics → Local durable state`

A component/abstraction belongs in V1 only if at least one is true:
1. directly required by V1 user behavior;
2. prevents a known P0/P1 correctness/security/data-loss risk;
3. avoids a near-certain high-cost rewrite in the next committed milestone;
4. is required by the HarmonyOS platform/toolchain.

Do not add infrastructure only because another music app might need it later.

Advanced features may be gated/deferred and must not block the core journey.
