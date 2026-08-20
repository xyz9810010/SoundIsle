import { Album, Artist, Song } from '../domain/model/MediaModels';
import { MediaKey, mediaKeyStableId } from '../domain/model/MediaKey';
import { AudioSourceType, DownloadState } from '../domain/model/StateTypes';
import { DownloadRecord, DownloadRepository } from '../domain/repository/DownloadRepository';
import { FavoriteRepository } from '../domain/repository/FavoriteRepository';
import { MusicRepository } from '../domain/repository/MusicRepository';
import { PlaylistRepository } from '../domain/repository/PlaylistRepository';
import { ServerRepository } from '../domain/repository/ServerRepository';
import { LocalFavorite, LocalPlaylist, LocalPlaylistItem, ServerProfile } from '../domain/model/UserModels';

// M0 in-memory repository skeletons. They honor the domain invariants (e.g. media
// identity is keyed by the full MediaKey, never collapsed to a remote id) and are
// replaced by provider/DB-backed implementations in M1+.

export class InMemoryMusicRepository implements MusicRepository {
  private readonly albums: Album[] = [];
  private readonly artists: Artist[] = [];
  private readonly songs: Song[] = [];

  async listAlbums(): Promise<Album[]> {
    return this.albums.slice();
  }

  async listArtists(): Promise<Artist[]> {
    return this.artists.slice();
  }

  async listSongs(): Promise<Song[]> {
    return this.songs.slice();
  }

  async search(query: string): Promise<Song[]> {
    const q: string = query.toLowerCase();
    return this.songs.filter((s: Song): boolean => s.title.toLowerCase().includes(q));
  }
}

export class InMemoryFavoriteRepository implements FavoriteRepository {
  private readonly favorites: Map<string, LocalFavorite> = new Map<string, LocalFavorite>();

  async list(): Promise<LocalFavorite[]> {
    const result: LocalFavorite[] = [];
    this.favorites.forEach((v: LocalFavorite): void => {
      result.push(v);
    });
    return result;
  }

  async isFavorite(key: MediaKey): Promise<boolean> {
    return this.favorites.has(mediaKeyStableId(key));
  }

  async add(key: MediaKey): Promise<void> {
    const favorite: LocalFavorite = {
      mediaKey: key,
      createdAtMs: Date.now(),
      serverSyncState: 'LOCAL_ONLY',
      orphanState: 'ACTIVE'
    };
    this.favorites.set(mediaKeyStableId(key), favorite);
  }

  async remove(key: MediaKey): Promise<void> {
    this.favorites.delete(mediaKeyStableId(key));
  }
}

export class InMemoryPlaylistRepository implements PlaylistRepository {
  private readonly playlists: Map<string, LocalPlaylist> = new Map<string, LocalPlaylist>();
  private readonly items: LocalPlaylistItem[] = [];
  private nextId: number = 1;

  async list(): Promise<LocalPlaylist[]> {
    const result: LocalPlaylist[] = [];
    this.playlists.forEach((v: LocalPlaylist): void => {
      result.push(v);
    });
    return result;
  }

  async create(name: string): Promise<LocalPlaylist> {
    const id: string = 'lp_' + this.nextId;
    this.nextId += 1;
    const now: number = Date.now();
    const playlist: LocalPlaylist = { id: id, name: name, createdAtMs: now, updatedAtMs: now };
    this.playlists.set(id, playlist);
    return playlist;
  }

  async rename(id: string, name: string): Promise<void> {
    const existing: LocalPlaylist | undefined = this.playlists.get(id);
    if (existing === undefined) {
      throw new Error('Playlist not found: ' + id);
    }
    const renamed: LocalPlaylist = {
      id: existing.id,
      name: name,
      createdAtMs: existing.createdAtMs,
      updatedAtMs: Date.now()
    };
    this.playlists.set(id, renamed);
  }

  async remove(id: string): Promise<void> {
    this.playlists.delete(id);
    for (let i = this.items.length - 1; i >= 0; i--) {
      if (this.items[i].playlistId === id) {
        this.items.splice(i, 1);
      }
    }
  }

  async listItems(playlistId: string): Promise<LocalPlaylistItem[]> {
    return this.items.filter((i: LocalPlaylistItem): boolean => i.playlistId === playlistId);
  }

  async addItem(playlistId: string, key: MediaKey): Promise<void> {
    const position: number = this.items.filter((i: LocalPlaylistItem): boolean => i.playlistId === playlistId).length;
    const item: LocalPlaylistItem = { playlistId: playlistId, position: position, mediaKey: key };
    this.items.push(item);
  }

  async removeItem(playlistId: string, key: MediaKey): Promise<void> {
    for (let i = this.items.length - 1; i >= 0; i--) {
      const item: LocalPlaylistItem = this.items[i];
      if (item.playlistId === playlistId && mediaKeyStableId(item.mediaKey) === mediaKeyStableId(key)) {
        this.items.splice(i, 1);
      }
    }
  }
}

export class InMemoryServerRepository implements ServerRepository {
  private readonly servers: Map<string, ServerProfile> = new Map<string, ServerProfile>();

  async list(): Promise<ServerProfile[]> {
    const result: ServerProfile[] = [];
    this.servers.forEach((v: ServerProfile): void => {
      result.push(v);
    });
    return result;
  }

  async get(id: string): Promise<ServerProfile> {
    const server: ServerProfile | undefined = this.servers.get(id);
    if (server === undefined) {
      throw new Error('Server profile not found: ' + id);
    }
    return server;
  }

  async create(profile: ServerProfile): Promise<void> {
    if (this.servers.has(profile.id)) {
      throw new Error('Server already exists: ' + profile.id);
    }
    this.servers.set(profile.id, profile);
  }

  async update(profile: ServerProfile): Promise<void> {
    if (!this.servers.has(profile.id)) {
      throw new Error('Server profile not found: ' + profile.id);
    }
    this.servers.set(profile.id, profile);
  }

  async remove(id: string): Promise<void> {
    this.servers.delete(id);
  }
}

export class InMemoryDownloadRepository implements DownloadRepository {
  private readonly records: Map<string, DownloadRecord> = new Map<string, DownloadRecord>();

  async list(): Promise<DownloadRecord[]> {
    const result: DownloadRecord[] = [];
    this.records.forEach((v: DownloadRecord): void => {
      result.push(v);
    });
    return result;
  }

  async enqueue(key: MediaKey, sourceType: AudioSourceType): Promise<void> {
    const record: DownloadRecord = { key: key, state: 'PENDING', sourceType: sourceType, createdAtMs: Date.now() };
    this.records.set(mediaKeyStableId(key), record);
  }

  async remove(key: MediaKey): Promise<void> {
    this.records.delete(mediaKeyStableId(key));
  }

  async getState(key: MediaKey): Promise<DownloadState> {
    const record: DownloadRecord | undefined = this.records.get(mediaKeyStableId(key));
    return record === undefined ? 'REMOVED' : record.state;
  }
}
