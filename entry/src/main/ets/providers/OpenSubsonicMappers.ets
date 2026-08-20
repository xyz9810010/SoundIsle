import { DomainError } from '../domain/error/DomainError';
import { Page } from '../domain/Page';
import { makeMediaKey } from '../domain/model/MediaKey';
import { Album, Artist, Song } from '../domain/model/MediaModels';
import { AlbumDto, ArtistDto, GenreDto, SongDto, SubsonicResponseDto, SubsonicResponseRoot } from './OpenSubsonicDtos';

export function mapGenres(genres: GenreDto[] | undefined): string[] {
  const result: string[] = [];
  if (genres === undefined) {
    return result;
  }
  for (let i = 0; i < genres.length; i++) {
    const name: string | undefined = genres[i].name;
    if (name !== undefined) {
      result.push(name);
    }
  }
  return result;
}

export function mapArtistDto(dto: ArtistDto, serverId: string): Artist | undefined {
  if (dto.id === undefined || dto.name === undefined) {
    return undefined;
  }
  return {
    key: makeMediaKey('OPENSUBSONIC', serverId, 'ARTIST', dto.id),
    name: dto.name,
    albumCount: dto.albumCount,
    coverArtId: dto.coverArt
  };
}

export function mapAlbumDto(dto: AlbumDto, serverId: string): Album | undefined {
  if (dto.id === undefined || dto.name === undefined) {
    return undefined;
  }
  return {
    key: makeMediaKey('OPENSUBSONIC', serverId, 'ALBUM', dto.id),
    name: dto.name,
    artistNames: dto.artist === undefined ? [] : [dto.artist],
    albumArtist: dto.artist,
    genres: mapGenres(dto.genres),
    coverArtId: dto.coverArt,
    songCount: dto.songCount,
    durationMs: dto.duration === undefined ? undefined : dto.duration * 1000
  };
}

export function mapSongDto(dto: SongDto, serverId: string): Song | undefined {
  if (dto.id === undefined || dto.title === undefined) {
    return undefined;
  }
  return {
    key: makeMediaKey('OPENSUBSONIC', serverId, 'SONG', dto.id),
    title: dto.title,
    artistNames: dto.artist === undefined ? [] : [dto.artist],
    artistIds: dto.artistId === undefined ? [] : [dto.artistId],
    albumId: dto.albumId,
    albumName: dto.album,
    durationMs: dto.duration === undefined ? 0 : dto.duration * 1000,
    trackNumber: dto.track,
    genres: mapGenres(dto.genres),
    coverArtId: dto.coverArt,
    suffix: dto.suffix,
    bitrateBps: dto.bitRate,
    sizeBytes: dto.size,
    channels: dto.channelCount,
    sampleRateHz: dto.samplingRate,
    bitDepth: dto.bitDepth
  };
}

export function parseSubsonicResponse(body: string): SubsonicResponseDto {
  let root: SubsonicResponseDto | undefined;
  try {
    const normalized: string = body.replace('"subsonic-response"', '"subsonicResponse"');
    const parsed: SubsonicResponseRoot = JSON.parse(normalized) as SubsonicResponseRoot;
    root = parsed.subsonicResponse;
  } catch (e) {
    throw new DomainError('INVALID_RESPONSE', 'Malformed OpenSubsonic response', false);
  }
  if (root === undefined) {
    throw new DomainError('INVALID_RESPONSE', 'Missing subsonic-response', false);
  }
  if (root.status === 'failed') {
    const code: number = root.error === undefined ? 0 : (root.error.code === undefined ? 0 : root.error.code);
    if (code === 30 || code === 40) {
      throw new DomainError('AUTHENTICATION', 'OpenSubsonic auth failed', false);
    }
    throw new DomainError('SERVER_UNAVAILABLE', 'OpenSubsonic server error', false);
  }
  return root;
}

export function parseArtistsResponse(body: string, serverId: string, pageSize: number): Page<Artist> {
  const root: SubsonicResponseDto = parseSubsonicResponse(body);
  const artists: Artist[] = [];
  const indexes = root.artists === undefined ? [] : (root.artists.index ?? []);
  for (let i = 0; i < indexes.length; i++) {
    const list: ArtistDto[] = indexes[i].artist ?? [];
    for (let j = 0; j < list.length; j++) {
      const mapped: Artist | undefined = mapArtistDto(list[j], serverId);
      if (mapped !== undefined) {
        artists.push(mapped);
      }
    }
  }
  return { items: artists, hasMore: artists.length >= pageSize };
}

export function parseAlbumList2Response(body: string, serverId: string, pageSize: number): Page<Album> {
  const root: SubsonicResponseDto = parseSubsonicResponse(body);
  const albums: Album[] = [];
  const list: AlbumDto[] = root.albumList2 === undefined ? [] : (root.albumList2.album ?? []);
  for (let i = 0; i < list.length; i++) {
    const mapped: Album | undefined = mapAlbumDto(list[i], serverId);
    if (mapped !== undefined) {
      albums.push(mapped);
    }
  }
  return { items: albums, hasMore: albums.length >= pageSize };
}

export function parseSearch3Response(body: string, serverId: string, pageSize: number): Page<Song> {
  const root: SubsonicResponseDto = parseSubsonicResponse(body);
  const songs: Song[] = [];
  const list: SongDto[] = root.searchResult3 === undefined ? [] : (root.searchResult3.song ?? []);
  for (let i = 0; i < list.length; i++) {
    const mapped: Song | undefined = mapSongDto(list[i], serverId);
    if (mapped !== undefined) {
      songs.push(mapped);
    }
  }
  return { items: songs, hasMore: songs.length >= pageSize };
}
