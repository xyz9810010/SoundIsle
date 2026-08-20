import { MediaKey } from '../model/MediaKey';
import { Album, Artist, Song } from '../model/MediaModels';
import { AudioSource } from '../model/QueueModels';
import { Page } from '../Page';
import { ServerProfile } from '../model/UserModels';
import { ServerPinger } from '../server/ServerConnection';

export interface ProviderCapabilities {
  readonly browseArtists: boolean;
  readonly browseAlbums: boolean;
  readonly browseSongs: boolean;
  readonly search: boolean;
  readonly coverArt: boolean;
  readonly lyricsPlain: boolean;
  readonly lyricsSynced: boolean;
  readonly streamOriginal: boolean;
  readonly transcode: boolean;
  readonly download: boolean;
  readonly serverFavorite: boolean;
  readonly rating: boolean;
  readonly playlistCrud: boolean;
  readonly scrobble: boolean;
  readonly playQueueSync: boolean;
}

export function emptyCapabilities(): ProviderCapabilities {
  return {
    browseArtists: false,
    browseAlbums: false,
    browseSongs: false,
    search: false,
    coverArt: false,
    lyricsPlain: false,
    lyricsSynced: false,
    streamOriginal: false,
    transcode: false,
    download: false,
    serverFavorite: false,
    rating: false,
    playlistCrud: false,
    scrobble: false,
    playQueueSync: false
  };
}

// Every server integration is a replaceable adapter (PROVIDER_CONTRACT.md).
export interface Provider extends ServerPinger {
  readonly profile: ServerProfile;
  readonly capabilities: ProviderCapabilities;

  listArtists(username: string, password: string, offset: number, size: number): Promise<Page<Artist>>;
  listAlbums(username: string, password: string, offset: number, size: number): Promise<Page<Album>>;
  search(username: string, password: string, query: string, offset: number, size: number): Promise<Page<Song>>;
  discoverCapabilities(username: string, password: string): Promise<ProviderCapabilities>;
  resolveAudioSource(username: string, password: string, key: MediaKey): Promise<AudioSource>;
  getCoverArtUrl(coverArtId: string): string;
}

export interface ProviderFactory {
  create(profile: ServerProfile): Provider;
}
