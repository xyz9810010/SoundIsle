import { MediaKey } from './MediaKey';
import { FavoriteSyncState, OrphanState, ProviderType } from './StateTypes';

// Non-sensitive server identity. Passwords/tokens live only in secure storage,
// referenced here by credentialRef (never stored as plaintext).
export interface ServerProfile {
  readonly id: string;
  readonly name: string;
  readonly providerType: ProviderType;
  readonly primaryUrl: string;
  readonly lanUrl?: string;
  readonly alternativeUrls: string[];
  readonly username?: string;
  readonly credentialRef: string;
  readonly enabled: boolean;
  readonly createdAtMs: number;
  readonly updatedAtMs: number;
}

export interface LocalFavorite {
  readonly mediaKey: MediaKey;
  readonly createdAtMs: number;
  readonly serverSyncState: FavoriteSyncState;
  readonly orphanState: OrphanState;
}

export interface LocalPlaylist {
  readonly id: string;
  readonly name: string;
  readonly createdAtMs: number;
  readonly updatedAtMs: number;
}

export interface LocalPlaylistItem {
  readonly playlistId: string;
  readonly position: number;
  readonly mediaKey: MediaKey;
  readonly titleSnapshot?: string;
  readonly artistSnapshot?: string;
  readonly albumSnapshot?: string;
}
