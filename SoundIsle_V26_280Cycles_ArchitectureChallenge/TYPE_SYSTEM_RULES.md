# SoundIsle ArkTS Type System Rules

## Core Rules
- Avoid `any` in normative/core code.
- Parse unknown JSON defensively into DTOs.
- Never use unchecked `as DomainType` to skip validation.
- Optional fields have one documented meaning.
- Normalize empty-string vs undefined/null semantics at the mapper boundary.
- Use centralized enums/string-union-like definitions for states/capabilities/errors.

## Number Safety
JavaScript/ArkTS numeric values may lose integer precision beyond the safe integer range.
For remote sizes/counters/timestamps that may exceed safe integer bounds:
- validate before conversion;
- keep as string if exactness matters;
- never silently round identity-like numeric values.

## Async Contracts
A single architectural layer should not randomly mix:
- nullable return for failure
- thrown exception
- Result object
for equivalent operations.

Pick one contract per API family and document it.

## DTO/Domain/Persistence
Maintain separate:
`Remote DTO → Domain → Presentation`
and
`Persistence DTO ↔ Domain`

Domain evolution must not silently change on-disk schema.
