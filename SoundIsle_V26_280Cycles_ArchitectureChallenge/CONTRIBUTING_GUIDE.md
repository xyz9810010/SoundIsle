# SoundIsle Contributing Guide

## Before Coding
Read `START_HERE.md`.

## Small Changes
Declare affected task/specs, implement the smallest correct change, run applicable tests, update status.

## Architecture Changes
Use an ADR and follow `REVIEW_EVIDENCE_POLICY.md`. Another possible architecture is not sufficient reason to replace the current one.

## Provider Contributions
Read:
- PROVIDER_CONTRACT.md
- MODULE_CONTRACTS.md
- DATA_MODEL.md
- ERROR_CONTRACTS.md
- relevant provider API spec
- TEST_PLAN.md

Do not modify core player UI just to add a provider unless a missing general capability is proven.

## Review
A contribution should preserve `SYSTEM_INVARIANTS.md` and satisfy `DEFINITION_OF_DONE.md`.
