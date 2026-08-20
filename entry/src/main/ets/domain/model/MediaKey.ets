import { MediaType } from './StateTypes';

// Remote media identity is namespaced by provider + server + media type + remote id.
// It must never be collapsed to a plain remote id (DATA_MODEL invariants).
export interface MediaKey {
  readonly providerId: string;
  readonly serverId: string;
  readonly mediaType: MediaType;
  readonly remoteId: string;
}

export function makeMediaKey(providerId: string, serverId: string, mediaType: MediaType, remoteId: string): MediaKey {
  return { providerId: providerId, serverId: serverId, mediaType: mediaType, remoteId: remoteId };
}

export function mediaKeyEquals(a: MediaKey, b: MediaKey): boolean {
  return a.providerId === b.providerId &&
    a.serverId === b.serverId &&
    a.mediaType === b.mediaType &&
    a.remoteId === b.remoteId;
}

// Stable, collision-safe string form of a MediaKey (never just the remote id).
export function mediaKeyStableId(key: MediaKey): string {
  return key.providerId + '|' + key.serverId + '|' + key.mediaType + '|' + key.remoteId;
}
