# SoundIsle Server Connection Flow

## Add Server
1. Normalize/validate address shape locally.
2. Collect username/password/API credential as applicable.
3. Create an **ephemeral** connection/session.
4. Ping/authenticate.
5. Discover basic server/protocol identity.
6. Discover optional capabilities.
7. Only after successful minimum validation:
   - store secret in SecureStorage;
   - create durable ServerProfile with credentialRef.
8. If durable save fails, clean up newly stored secret where possible.

A failed connection attempt must not leave a half-created usable profile.

## Edit Existing Server
Keep stable `serverId`. Validate new connection parameters before committing destructive credential/address changes when practical.
