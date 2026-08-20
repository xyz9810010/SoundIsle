# SoundIsle Test Double Policy

Prefer:
1. real pure objects;
2. deterministic fakes;
3. contract fixtures;
4. mocks only when interaction itself is the behavior under test.

A test that only asserts `method X was called once` does not prove user-visible/state correctness.

Provider fakes should emulate stable Provider contracts, not expose transport-library details.
