# V15 Changelog — 60 Cycles

Added 20 multidimensional cycles (41–60).

New:
- DOC_INDEX.md
- FEATURE_GATES.md
- DATA_RECOVERY.md
- LYRICS_CONTRACT.md

Key decisions:
- documentation tiers reduce AI overload;
- no speculative cross-platform abstraction;
- no V1 dynamic Provider plugin system;
- offline cache remains usable despite Remote Authority;
- feature gates prevent unverified features from leaking into release;
- database corruption never triggers silent reset;
- background playback does not justify unrelated polling;
- lyrics timing standardized to milliseconds;
- locale/Unicode behavior explicitly protected.

Verdict: V15 / 60 cumulative cycles converged.
