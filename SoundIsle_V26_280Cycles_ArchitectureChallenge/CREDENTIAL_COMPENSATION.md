# SoundIsle Credential Compensation Policy

SecureStorage and RDB may not share one transaction.

When adding/updating a server:
1. validate ephemeral connection;
2. write new credential;
3. write/update ServerProfile credentialRef;
4. if profile persistence fails, attempt compensating deletion of the newly-created credential;
5. never delete an old credential until the new durable profile reference is safely committed.

Startup/maintenance may identify unreferenced SoundIsle-owned credential records and clean them using a conservative ownership marker/version policy.
