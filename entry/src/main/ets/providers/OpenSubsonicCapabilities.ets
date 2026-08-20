import { ProviderCapabilities } from '../domain/provider/Provider';
import { SubsonicResponseDto } from './OpenSubsonicDtos';
import { parseSubsonicResponse } from './OpenSubsonicMappers';

// Returns the extension NAMES advertised by getOpenSubsonicExtensions.
export function parseOpenSubsonicExtensions(body: string): string[] {
  let root: SubsonicResponseDto;
  try {
    root = parseSubsonicResponse(body);
  } catch (e) {
    return [];
  }
  const list = root.openSubsonicExtensions ?? [];
  const names: string[] = [];
  for (let i = 0; i < list.length; i++) {
    const name: string | undefined = list[i].name;
    if (name !== undefined) {
      names.push(name);
    }
  }
  return names;
}

function contains(items: string[], target: string): boolean {
  for (let i = 0; i < items.length; i++) {
    if (items[i] === target) {
      return true;
    }
  }
  return false;
}

// Conservative capability flags: base Subsonic read/write APIs are true (they are part
// of the core protocol); extension-gated capabilities are true only when the server
// advertises the matching OpenSubsonic extension.
export function buildCapabilities(extensions: string[]): ProviderCapabilities {
  const lyrics: boolean = contains(extensions, 'songLyrics');
  return {
    browseArtists: true,
    browseAlbums: true,
    browseSongs: true,
    search: true,
    coverArt: true,
    streamOriginal: true,
    transcode: true,
    download: true,
    serverFavorite: true,
    rating: true,
    playlistCrud: true,
    scrobble: true,
    lyricsPlain: lyrics,
    lyricsSynced: lyrics,
    playQueueSync: contains(extensions, 'savePlayQueue')
  };
}
