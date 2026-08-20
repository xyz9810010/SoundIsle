# SoundIsle Background Media Requirements

Background playback, media session, lock-screen controls and system media presentation are DEVICE_TEST_REQUIRED capabilities.

Rules:
- use documented HarmonyOS mechanisms discovered from the real SDK/project;
- do not invent Android foreground-service equivalents;
- required permissions/capabilities/configuration must be verified in Release configuration;
- media metadata is projected from the same current PlayerState;
- external play/pause/next/previous/seek commands enter PlayerController;
- background continuation must survive Page destruction where platform policy permits.

Exact API names remain implementation-discovery items until verified against the actual HarmonyOS SDK used by the repository.
