import { describe, expect, it } from '@ohos/hypium';
import { joinUrl, normalizeBaseUrl } from '../main/ets/domain/url/ServerUrl';

export default function serverUrlTest() {
  describe('normalizeBaseUrl', () => {
    it('adds_http_scheme_for_bare_host', 0, () => {
      expect(normalizeBaseUrl('192.168.1.5:4533')).assertEqual('http://192.168.1.5:4533');
    });

    it('keeps_https_scheme', 0, () => {
      expect(normalizeBaseUrl('https://music.example.com')).assertEqual('https://music.example.com');
    });

    it('strips_trailing_slash', 0, () => {
      expect(normalizeBaseUrl('https://music.example.com/')).assertEqual('https://music.example.com');
    });

    it('preserves_base_path_without_trailing_slash', 0, () => {
      expect(normalizeBaseUrl('https://music.example.com/music/')).assertEqual('https://music.example.com/music');
    });

    it('trims_whitespace', 0, () => {
      expect(normalizeBaseUrl('  http://10.0.0.5:4040/  ')).assertEqual('http://10.0.0.5:4040');
    });

    it('keeps_port', 0, () => {
      expect(normalizeBaseUrl('music.local:4533')).assertEqual('http://music.local:4533');
    });
  });

  describe('joinUrl', () => {
    it('joins_rest_path_under_base_path', 0, () => {
      expect(joinUrl('https://music.example.com/music', 'rest', 'ping')).assertEqual('https://music.example.com/music/rest/ping');
    });

    it('no_double_slash_for_bare_host', 0, () => {
      expect(joinUrl('http://192.168.1.5:4533', '/rest/', '/ping')).assertEqual('http://192.168.1.5:4533/rest/ping');
    });
  });
}
