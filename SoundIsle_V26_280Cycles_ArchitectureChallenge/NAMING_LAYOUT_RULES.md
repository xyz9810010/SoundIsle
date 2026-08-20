# SoundIsle Naming & Layout Rules

## Avoid Generic Dumping Grounds
Do not create:
- `utils/` containing unrelated business logic
- `common/` for arbitrary code
- `manager/` as a catch-all
- `helpers/` with cross-layer dependencies

## Naming
Names describe responsibility:
- `PlaybackResolver`
- `QueueManager`
- `OpenSubsonicProvider`
- `FavoriteRepository`
- `ServerProfileStore`

Avoid ambiguous duplicates:
- `MusicManager`
- `DataManager`
- `PlayerManager2`
- `CommonService`

## Suggested Feature/Layer Organization
Keep module/package boundaries aligned with architecture, not page count alone.

Files should stay small enough to preserve one primary responsibility, but avoid one-class-per-trivial-action over-fragmentation.
