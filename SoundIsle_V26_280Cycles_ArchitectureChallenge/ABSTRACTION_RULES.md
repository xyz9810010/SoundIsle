# SoundIsle Abstraction Rules

Create an interface/abstraction when it protects a real boundary:
- cross-layer contract;
- replaceable provider/platform implementation;
- lifecycle ownership;
- test isolation where a fake is useful;
- protocol/persistence translation boundary.

Do not create:
- one interface for every one-method class;
- empty future-provider methods;
- generic BaseManager/BaseService without proven shared semantics;
- wrapper-on-wrapper layers that only rename a call.

Repository is a boundary, not a naming convention. Group cohesive data operations where sensible.

Mappers:
- Remote DTO → Domain: explicit mapping required.
- Persistence DTO ↔ Domain: explicit mapping required.
- Domain → Presentation: lightweight pure conversion is sufficient; a Mapper class is optional.
