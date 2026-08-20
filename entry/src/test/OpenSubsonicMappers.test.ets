import { describe, expect, it } from '@ohos/hypium';
import { parseAlbumList2Response, parseArtistsResponse, parseSearch3Response } from '../main/ets/providers/OpenSubsonicMappers';
import { DomainError } from '../main/ets/domain/error/DomainError';

export default function openSubsonicMappersTest() {
  describe('parseAlbumList2Response', () => {
    it('maps_album_fields_and_duration_ms', 0, () => {
      const json: string = '{"subsonic-response":{"status":"ok","albumList2":{"album":[{"id":"al-1","name":"Album One","artist":"Artist One","artistId":"ar-1","coverArt":"al-1","songCount":10,"duration":3600,"genres":[{"name":"Rock"}]}]}}}';
      const page = parseAlbumList2Response(json, 'srv1', 50);
      expect(page.items.length).assertEqual(1);
      const a = page.items[0];
      expect(a.name).assertEqual('Album One');
      expect(a.artistNames[0]).assertEqual('Artist One');
      expect(a.genres[0]).assertEqual('Rock');
      expect(a.durationMs).assertEqual(3600000);
      expect(a.songCount).assertEqual(10);
      expect(a.key.remoteId).assertEqual('al-1');
      expect(a.key.mediaType).assertEqual('ALBUM');
      expect(a.key.serverId).assertEqual('srv1');
    });

    it('hasMore_true_when_page_full', 0, () => {
      const json: string = '{"subsonic-response":{"status":"ok","albumList2":{"album":[{"id":"al-1","name":"A"},{"id":"al-2","name":"B"}]}}}';
      expect(parseAlbumList2Response(json, 'srv1', 2).hasMore).assertTrue();
      expect(parseAlbumList2Response(json, 'srv1', 3).hasMore).assertFalse();
    });
  });

  describe('parseArtistsResponse', () => {
    it('flattens_artists_from_index', 0, () => {
      const json: string = '{"subsonic-response":{"status":"ok","artists":{"index":[{"name":"A","artist":[{"id":"ar-1","name":"Alice","albumCount":3,"coverArt":"ar-1"}]},{"name":"B","artist":[{"id":"ar-2","name":"Bob"}]}]}}}';
      const page = parseArtistsResponse(json, 'srv1', 50);
      expect(page.items.length).assertEqual(2);
      expect(page.items[0].name).assertEqual('Alice');
      expect(page.items[0].albumCount).assertEqual(3);
      expect(page.items[1].name).assertEqual('Bob');
    });
  });

  describe('parseSearch3Response', () => {
    it('maps_song_fields', 0, () => {
      const json: string = '{"subsonic-response":{"status":"ok","searchResult3":{"song":[{"id":"s-1","title":"Song One","artist":"Alice","artistId":"ar-1","album":"Album One","albumId":"al-1","duration":180,"track":1,"genres":[{"name":"Rock"}],"suffix":"mp3","bitRate":320,"size":7200000,"channelCount":2,"samplingRate":44100,"bitDepth":16}]}}}';
      const page = parseSearch3Response(json, 'srv1', 50);
      expect(page.items.length).assertEqual(1);
      const s = page.items[0];
      expect(s.title).assertEqual('Song One');
      expect(s.genres[0]).assertEqual('Rock');
      expect(s.durationMs).assertEqual(180000);
      expect(s.bitrateBps).assertEqual(320);
      expect(s.sizeBytes).assertEqual(7200000);
      expect(s.channels).assertEqual(2);
      expect(s.sampleRateHz).assertEqual(44100);
      expect(s.bitDepth).assertEqual(16);
      expect(s.key.mediaType).assertEqual('SONG');
    });
  });

  describe('error handling', () => {
    it('failed_auth_throws_authentication', 0, () => {
      const json: string = '{"subsonic-response":{"status":"failed","error":{"code":40,"message":"wrong"}}}';
      let threw: boolean = false;
      let category: string = '';
      try {
        parseAlbumList2Response(json, 'srv1', 50);
      } catch (e) {
        threw = true;
        if (e instanceof DomainError) {
          category = e.category;
        }
      }
      expect(threw).assertTrue();
      expect(category).assertEqual('AUTHENTICATION');
    });

    it('malformed_json_throws_invalid_response', 0, () => {
      let threw: boolean = false;
      let category: string = '';
      try {
        parseAlbumList2Response('not-json', 'srv1', 50);
      } catch (e) {
        threw = true;
        if (e instanceof DomainError) {
          category = e.category;
        }
      }
      expect(threw).assertTrue();
      expect(category).assertEqual('INVALID_RESPONSE');
    });
  });
}
