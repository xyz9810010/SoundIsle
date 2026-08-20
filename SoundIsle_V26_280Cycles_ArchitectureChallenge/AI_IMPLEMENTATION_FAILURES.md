# Common AI Implementation Failures

AI agents must actively check for these before claiming a task complete:

- inventing HarmonyOS APIs from Android/iOS analogies;
- weakening types to `any`;
- putting secrets in Preferences/RDB;
- hardcoding `/rest` without preserving reverse-proxy base path;
- returning Provider DTOs from Repository;
- creating one giant `SubsonicResponse`;
- page-level `new Repository()` / `new AVPlayer`;
- implementing M2 playback during M0;
- writing guessed build commands;
- using mocks to claim DEVICE_TESTED;
- adding a second PlayerStateStore/QueueManager;
- logging auth query/header values;
- loading full libraries instead of paginating.
