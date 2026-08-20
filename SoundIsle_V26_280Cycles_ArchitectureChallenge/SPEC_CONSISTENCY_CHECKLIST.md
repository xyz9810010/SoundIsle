# SoundIsle Spec Consistency Checklist

Before merging a normative spec change, check:

- terminology matches `GLOSSARY.md`;
- units match DATA_MODEL conventions;
- state names match PLAYBACK_STATE_MACHINE/SYSTEM_INVARIANTS;
- error names match ERROR_MODEL/ERROR_CONTRACTS;
- feature status matches FEATURE_GATES;
- task scope matches CURRENT_MILESTONE;
- no lower-priority spec overrides a higher-priority one;
- DOC_INDEX and TASK_SPEC_MAPPING references remain valid;
- duplicated rules are replaced with links to the normative source;
- superseded ADR/spec text is clearly marked or archived.
