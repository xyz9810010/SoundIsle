import { MediaKey } from './MediaKey';
import { Song } from './MediaModels';
import { AudioSourceType, PlaybackOriginKind } from './StateTypes';

export interface QueueItem {
  readonly key: MediaKey;
  readonly titleSnapshot: string;
  readonly artistSnapshot: string;
  readonly albumSnapshot?: string;
  readonly coverArtIdSnapshot?: string;
  readonly durationMs?: number;
}

export interface PlaybackOrigin {
  readonly kind: PlaybackOriginKind;
  readonly key?: MediaKey;
  readonly title?: string;
}

export interface QueueSeed {
  readonly items: QueueItem[];
  readonly currentIndex: number;
  readonly origin: PlaybackOrigin;
}

export function songToQueueItem(song: Song): QueueItem {
  return {
    key: song.key,
    titleSnapshot: song.title,
    artistSnapshot: song.artistNames.length > 0 ? song.artistNames[0] : '',
    albumSnapshot: song.albumName,
    coverArtIdSnapshot: song.coverArtId,
    durationMs: song.durationMs
  };
}

export function singleSongSeed(song: Song, originKind: PlaybackOriginKind): QueueSeed {
  return {
    items: [songToQueueItem(song)],
    currentIndex: 0,
    origin: { kind: originKind, key: song.key, title: song.title }
  };
}

// What is actually being played.
export interface AudioSource {
  readonly mediaKey: MediaKey;
  readonly uri: string;
  readonly requestHeaders?: Map<string, string>;
  readonly routeId: string;
  readonly sourceType: AudioSourceType;
  readonly codec?: string;
  readonly container?: string;
  readonly bitrateBps?: number;
  readonly sampleRateHz?: number;
  readonly bitDepth?: number;
  readonly channels?: number;
  readonly contentLengthBytes?: number;
  readonly expiresAtEpochMs?: number;
}
