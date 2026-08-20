import { MediaKey } from '../model/MediaKey';
import { LocalPlaylist, LocalPlaylistItem } from '../model/UserModels';

export interface PlaylistRepository {
  list(): Promise<LocalPlaylist[]>;
  create(name: string): Promise<LocalPlaylist>;
  rename(id: string, name: string): Promise<void>;
  remove(id: string): Promise<void>;
  listItems(playlistId: string): Promise<LocalPlaylistItem[]>;
  addItem(playlistId: string, key: MediaKey): Promise<void>;
  removeItem(playlistId: string, key: MediaKey): Promise<void>;
}
