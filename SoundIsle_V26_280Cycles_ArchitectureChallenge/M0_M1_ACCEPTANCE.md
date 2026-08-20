# M0 / M1 Acceptance Detail

## M0
Pass when:
- clean checkout builds with documented real commands;
- app launches to navigation shell;
- dependency composition compiles;
- no page directly constructs core repository/provider/player dependencies;
- secure credential interface exists with no plaintext fallback;
- module boundary tests pass;
- PROJECT_STATUS contains evidence.

## M1
Pass when:
- a real supported Navidrome server can be validated;
- invalid credentials are distinguished from unreachable server;
- ServerProfile stores no plaintext password/token;
- capability discovery is conservative;
- artists/albums/songs/search map through DTO→Domain;
- large-list APIs use pagination contract;
- failed add-server leaves no broken profile;
- integration tests cover representative server responses.
