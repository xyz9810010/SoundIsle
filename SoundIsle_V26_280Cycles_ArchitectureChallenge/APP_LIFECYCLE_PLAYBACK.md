# SoundIsle App Lifecycle & Playback

## Ownership
Playback lifetime is application/service-session scoped, not Page scoped.

Page disappearance:
- must not destroy PlayerController;
- must not imply playback stop;
- may detach presentation observers.

## Persistence
Do not depend solely on one `onBackground` callback.
Persist critical queue/current-media/position state incrementally with throttling and perform best-effort lifecycle flushes.

## Process Death
After restart:
- restore durable queue snapshot;
- restore current media identity/position;
- do not auto-start audible playback unless product/platform policy explicitly allows it;
- re-resolve expiring remote sources.

## External Controls
Lock-screen/media-session/system controls all dispatch into the same PlayerController command path used by UI.
