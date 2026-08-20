import { describe, expect, it } from '@ohos/hypium';
import { buildCapabilities, parseOpenSubsonicExtensions } from '../main/ets/providers/OpenSubsonicCapabilities';

// Captured verbatim from the real Navidrome (0.61.2) getOpenSubsonicExtensions.
const REAL_EXTENSIONS_JSON: string =
  '{"subsonic-response":{"status":"ok","version":"1.16.1","type":"navidrome","serverVersion":"0.61.2 (aa84e645)","openSubsonic":true,"openSubsonicExtensions":[{"name":"transcodeOffset","versions":[1]},{"name":"formPost","versions":[1]},{"name":"songLyrics","versions":[1]},{"name":"indexBasedQueue","versions":[1]},{"name":"transcoding","versions":[1]}]}}';

export default function openSubsonicCapabilitiesTest() {
  describe('parseOpenSubsonicExtensions', () => {
    it('parses_real_extension_names', 0, () => {
      const names: string[] = parseOpenSubsonicExtensions(REAL_EXTENSIONS_JSON);
      expect(names.length).assertEqual(5);
      expect(names.includes('songLyrics')).assertTrue();
      expect(names.includes('transcoding')).assertTrue();
      expect(names.includes('savePlayQueue')).assertFalse();
    });
  });

  describe('buildCapabilities', () => {
    it('extension_gated_flags_conservative', 0, () => {
      const names: string[] = ['transcodeOffset', 'formPost', 'songLyrics', 'indexBasedQueue', 'transcoding'];
      const caps = buildCapabilities(names);
      expect(caps.lyricsPlain).assertTrue();
      expect(caps.lyricsSynced).assertTrue();
      expect(caps.playQueueSync).assertFalse();
      expect(caps.browseArtists).assertTrue();
      expect(caps.browseAlbums).assertTrue();
      expect(caps.search).assertTrue();
      expect(caps.streamOriginal).assertTrue();
    });

    it('empty_extensions_still_have_base_capabilities', 0, () => {
      const caps = buildCapabilities([]);
      expect(caps.lyricsPlain).assertFalse();
      expect(caps.playQueueSync).assertFalse();
      expect(caps.browseAlbums).assertTrue();
      expect(caps.search).assertTrue();
    });
  });
}
