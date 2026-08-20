# SoundIsle Lifecycle Policy

## Stable Server Identity
`serverId` is independent of URL. Editing LAN/WAN/primary URLs does not create a new identity.

## Server Removal
Stop new work, remove SecureStorage credentials, invalidate auth/capability state and clear disposable cache. Durable favorites/playlists/history/downloads follow an explicit user-facing policy and are never silently erased.

## Restart
Restore queue/current media/navigation state without unexpected audio. Default restart autoplay is off.

## Upgrade/Downgrade
Refresh capabilities after meaningful server changes. If local schema is newer than the running app supports, block unsafe writes; never recreate an empty DB.

## Time
Persist event timestamps as epoch milliseconds. Use monotonic elapsed time for runtime duration measurements where the platform permits.
