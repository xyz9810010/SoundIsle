# SoundIsle Active Specification Set

## Always Active
- START_HERE.md
- DOCUMENT_PRECEDENCE.md
- GLOSSARY.md
- CURRENT_MILESTONE.md
- SYSTEM_INVARIANTS.md
- DEFINITION_OF_DONE.md

## Task Active
Load direct `required_docs` from TASK_SPEC_MAPPING / task declaration.

Do not recursively load every document referenced by a required document unless a concrete ambiguity requires it.

## Non-Active by Default
- docs/archive/*
- old version changelogs
- historical review narratives
- competitor/context documents

The purpose is execution accuracy, not minimum file count.
