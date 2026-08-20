import { Album, Artist, Song } from '../model/MediaModels';

// Browse/search read path. M0 declares the contract only; a real provider-backed
// implementation lands in M1 (with pagination per PAGINATION_CONTRACT.md).
export interface MusicRepository {
  listAlbums(): Promise<Album[]>;
  listArtists(): Promise<Artist[]>;
  listSongs(): Promise<Song[]>;
  search(query: string): Promise<Song[]>;
}
