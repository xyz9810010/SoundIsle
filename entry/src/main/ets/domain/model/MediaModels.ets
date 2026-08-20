import { MediaKey } from './MediaKey';

export interface Song {
  readonly key: MediaKey;
  readonly title: string;
  readonly artistNames: string[];
  readonly artistIds?: string[];
  readonly albumId?: string;
  readonly albumName?: string;
  readonly albumArtist?: string;
  readonly composer?: string;
  readonly durationMs: number;
  readonly trackNumber?: number;
  readonly discNumber?: number;
  readonly year?: number;
  readonly genres: string[];
  readonly coverArtId?: string;
  readonly suffix?: string;
  readonly codecHint?: string;
  readonly bitrateBps?: number;
  readonly sampleRateHz?: number;
  readonly bitDepth?: number;
  readonly channels?: number;
  readonly sizeBytes?: number;
  readonly serverStarred?: boolean;
  readonly serverRating?: number;
}

export interface Album {
  readonly key: MediaKey;
  readonly name: string;
  readonly artistNames: string[];
  readonly albumArtist?: string;
  readonly year?: number;
  readonly genres: string[];
  readonly coverArtId?: string;
  readonly songCount?: number;
  readonly durationMs?: number;
}

export interface Artist {
  readonly key: MediaKey;
  readonly name: string;
  readonly albumCount?: number;
  readonly coverArtId?: string;
}
