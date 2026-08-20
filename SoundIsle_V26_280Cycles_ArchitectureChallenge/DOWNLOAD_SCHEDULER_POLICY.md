# SoundIsle Download Scheduler Policy

Downloads are centrally scheduled.

## Rules
- bounded global concurrency;
- optional per-server concurrency limit;
- playback/network-critical foreground work has priority;
- pause/cancel frees scheduler slots;
- retries obey RETRY_IDEMPOTENCY_MATRIX/NETWORK_EDGE_CASES;
- storage-full stops new work safely;
- app restart reconstructs runnable jobs from durable download state.

Do not create one uncontrolled downloader loop per UI task.
