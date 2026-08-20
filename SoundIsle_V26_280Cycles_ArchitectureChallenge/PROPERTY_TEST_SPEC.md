# SoundIsle Property / Model-Based Test Specification

Where tooling permits, generate event sequences rather than only hand-authored cases.

## Playback Model Properties
Given sequences of:
`Play(media), Pause, Resume, Seek, Next, Previous, NetworkChange, StreamFail, Interrupt, RouteLoss`

Assert:
- stale generation never becomes current;
- user pause prevents auto-start;
- recovery count never exceeds budget;
- current audible/source media matches currentMediaKey;
- no invalid state transition crashes.

## Queue Model Properties
Generate:
`Add, Remove, Move, Clear, ShuffleOn/Off, RepeatMode, Next, Previous`

Assert:
- index bounds invariant;
- current MediaKey preservation when possible;
- shuffle history identity consistency;
- persisted/reloaded model preserves semantics.

## Download Model Properties
Generate:
`Queue, Start, Pause, Resume, Fail, RestartApp, Verify, Delete`

Assert:
- COMPLETED implies valid final file;
- temp file never equals completed state;
- restart reconciliation converges to a valid state.
