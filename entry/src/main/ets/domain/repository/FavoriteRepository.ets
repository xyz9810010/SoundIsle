import { MediaKey } from '../model/MediaKey';
import { LocalFavorite } from '../model/UserModels';

export interface FavoriteRepository {
  list(): Promise<LocalFavorite[]>;
  isFavorite(key: MediaKey): Promise<boolean>;
  add(key: MediaKey): Promise<void>;
  remove(key: MediaKey): Promise<void>;
}
