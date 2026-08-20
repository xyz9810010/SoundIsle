// Centralized state/type definitions (TYPE_SYSTEM_RULES: centralized enums/string-union-like).
// String-literal union types are used so the compiler enforces the exact value set
// while avoiding any runtime enum baggage. Companion const arrays enable validation/tests.

export type MediaType = 'SONG' | 'ALBUM' | 'ARTIST' | 'PLAYLIST';
export const MEDIA_TYPES: MediaType[] = ['SONG', 'ALBUM', 'ARTIST', 'PLAYLIST'];

export type ProviderType = 'OPENSUBSONIC' | 'JELLYFIN' | 'EMBY' | 'AUDIO_STATION' | 'PLEX';

export type PlaybackOriginKind =
  'ALBUM' | 'PLAYLIST' | 'ARTIST' | 'SEARCH' | 'HOME' | 'FAVORITES' | 'DOWNLOADS' | 'SINGLE';

export type AudioSourceType = 'LOCAL_DOWNLOAD' | 'REMOTE_ORIGINAL' | 'REMOTE_TRANSCODE';

export type OrphanState = 'ACTIVE' | 'REMOTE_MISSING' | 'SERVER_REMOVED' | 'UNKNOWN';

// Favorite server-sync state. DATA_MODEL.md contains two variants; this follows the
// dedicated "Favorite Sync State" section (LOCAL_ONLY | SYNC_PENDING | SYNCED | SYNC_FAILED | UNSUPPORTED).
export type FavoriteSyncState = 'LOCAL_ONLY' | 'SYNC_PENDING' | 'SYNCED' | 'SYNC_FAILED' | 'UNSUPPORTED';

export type DownloadState = 'PENDING' | 'DOWNLOADING' | 'READY' | 'FAILED' | 'REMOVED';
