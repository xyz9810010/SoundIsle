# SoundIsle Acceptance Criteria

These criteria convert subjective requirements into verifiable outcomes.

## AC-ONB-001 Navidrome First Connection
**Given** a reachable supported Navidrome server and valid credentials  
**When** the user enters address/username/password and taps Connect  
**Then** SoundIsle verifies the server, stores non-sensitive profile data locally, stores credentials securely, and lands on usable music content without requiring API/codec configuration.

Failure variants must produce actionable user messages.

## AC-LIB-001 Library Does Not Require Full Sync
**Given** a large library  
**When** the user opens Albums/Songs/Artists  
**Then** first content can be shown through API pagination/cache without requiring a full server database mirror.

## AC-PLAY-001 Latest Selection Wins
**Given** user taps A, then B, then C rapidly  
**When** asynchronous source/prepare callbacks return out of order  
**Then** only C may become current/playable; stale A/B results cannot replace current state.

## AC-PLAY-002 User Pause Wins
**Given** a track is resolving/preparing  
**When** user presses Pause before prepare completes  
**Then** prepare may complete, but audio must not start until user explicitly requests Play again.

## AC-PLAY-003 Network Change Does Not Force Interruption
**Given** current playback still has a viable stream/buffer  
**When** network type changes  
**Then** SoundIsle does not rebuild the source solely because of the network event.

## AC-PLAY-004 Recovery
**Given** the active stream truly fails  
**When** an alternate route or refreshed source is available  
**Then** SoundIsle attempts bounded recovery, restores position within platform capability, and resumes only if user intent is still PLAY.

## AC-ROUTE-001 Unexpected Output Loss
**Given** audio is playing through Bluetooth/headphones  
**When** the route is unexpectedly lost  
**Then** SoundIsle prevents sudden speaker playback and pauses effective audio.

## AC-QUEUE-001 Album Context
**Given** a 10-track album  
**When** the user taps track 5  
**Then** the queue contains the full album context with currentIndex=5 (zero/one indexing implemented consistently), so previous/next can navigate both directions.

## AC-DL-001 Cache Safety
**Given** downloaded music and cached images/lyrics exist  
**When** user clears cache  
**Then** downloaded music and durable user data remain intact.

## AC-DL-002 Offline Playback
**Given** a verified downloaded track and no network  
**When** user plays it  
**Then** playback resolves to the local file without requiring Navidrome.

## AC-DATA-001 Restart Persistence
**Given** a non-empty queue/current track  
**When** app restarts  
**Then** queue/current media/play mode are restored and the app does not unexpectedly emit audio.

## AC-DATA-002 Upgrade Safety
**Given** a prior public/beta version with durable local data  
**When** upgrading to the new schema  
**Then** server profiles, local favorites, local playlists, history, downloads and settings are preserved or migration blocks release.

## AC-UX-001 User Comprehension
A first-time Navidrome user should be able to connect and play without understanding OpenSubsonic, codec, route, capability, or transcode terminology.

## AC-SYSTEM-001 Device Verification
Background, lock-screen/AVSession, Bluetooth control and interruption behavior cannot be marked DONE until real-device evidence exists.
