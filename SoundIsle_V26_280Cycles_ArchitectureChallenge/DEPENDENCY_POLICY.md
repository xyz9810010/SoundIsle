# SoundIsle Dependency Policy

Each new dependency must document:
- package/name
- pinned/locked version
- purpose
- license
- source/maintainer
- why platform/stdlib is insufficient
- security/maintenance considerations

Upgrades require:
- clean build
- relevant automated tests
- license/security recheck
- no silent major-version jumps

Avoid dependencies for trivial utilities that increase long-term maintenance risk.
