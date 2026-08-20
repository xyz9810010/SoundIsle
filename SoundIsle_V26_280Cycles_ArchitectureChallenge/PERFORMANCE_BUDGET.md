# SoundIsle Performance & Resource Budget

Exact numerical targets require real HarmonyOS measurement; do not invent them.

## Large Libraries
Use pagination/incremental rendering, bounded cancellable artwork requests, search generations, and avoid N+1 request storms. Never materialize 50k/100k items on the UI thread.

## 8-Hour Soak
Measure memory growth, resource leaks, log growth, DB write rate, battery impact, artwork allocations and recovery count.

## Database
Playback hot-path commands do not synchronously wait on non-critical history/cache writes. Position persistence is throttled with lifecycle flushes.

## Large Downloads
Cold start uses fast index/filesystem reconciliation, followed by incremental deep verification; never hash the entire offline library synchronously.

## Background Work
Foreground actions outrank metadata/artwork. Playback does not justify unrelated background polling.

## PR Request Fan-Out
List/home PRs should inspect initial request fan-out. Artwork/metadata loading must be bounded and lazy; correctness does not justify an unbounded first-screen request storm.
