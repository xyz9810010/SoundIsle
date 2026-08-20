export interface ArtistDto {
  id?: string;
  name?: string;
  albumCount?: number;
  coverArt?: string;
}

export interface ArtistIndexDto {
  name?: string;
  artist?: ArtistDto[];
}

export interface ArtistsDto {
  index?: ArtistIndexDto[];
}

export interface GenreDto {
  name?: string;
}

export interface AlbumDto {
  id?: string;
  name?: string;
  artist?: string;
  artistId?: string;
  coverArt?: string;
  songCount?: number;
  duration?: number;
  genres?: GenreDto[];
}

export interface AlbumList2Dto {
  album?: AlbumDto[];
}

export interface SongDto {
  id?: string;
  title?: string;
  artist?: string;
  artistId?: string;
  album?: string;
  albumId?: string;
  duration?: number;
  track?: number;
  coverArt?: string;
  suffix?: string;
  bitRate?: number;
  size?: number;
  genres?: GenreDto[];
  channelCount?: number;
  samplingRate?: number;
  bitDepth?: number;
}

export interface SearchResult3Dto {
  song?: SongDto[];
  artist?: ArtistDto[];
  album?: AlbumDto[];
}

export interface SubsonicErrorDto {
  code?: number;
  message?: string;
}

export interface OpenSubsonicExtensionDto {
  name?: string;
  versions?: number[];
}

// Top-level response (after normalizing the hyphenated "subsonic-response" key).
export interface SubsonicResponseDto {
  status?: string;
  version?: string;
  type?: string;
  serverVersion?: string;
  openSubsonic?: boolean;
  artists?: ArtistsDto;
  albumList2?: AlbumList2Dto;
  searchResult3?: SearchResult3Dto;
  openSubsonicExtensions?: OpenSubsonicExtensionDto[];
  error?: SubsonicErrorDto;
}

export interface SubsonicResponseRoot {
  subsonicResponse?: SubsonicResponseDto;
}
