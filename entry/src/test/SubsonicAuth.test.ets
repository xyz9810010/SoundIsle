import { describe, expect, it } from '@ohos/hypium';
import { buildAuthQuery, computeTokenHex, generateSalt, redactUrl } from '../main/ets/providers/SubsonicAuth';
import { hexEncode } from '../main/ets/infrastructure/Hex';

export default function subsonicAuthTest() {
  describe('SubsonicAuth', () => {
    it('generateSalt_returns_requested_length', 0, () => {
      expect(generateSalt().length).assertEqual(12);
      expect(generateSalt(16).length).assertEqual(16);
    });

    it('hexEncode_lowercase_hex', 0, () => {
      expect(hexEncode([0xde, 0xad, 0xbe, 0xef])).assertEqual('deadbeef');
      expect(hexEncode([0x00, 0xff, 0x10])).assertEqual('00ff10');
    });

    it('computeTokenHex_is_hex_of_md5_of_password_plus_salt', 0, () => {
      let captured: string = '';
      const fakeMd5 = (input: string): number[] => {
        captured = input;
        return [0xde, 0xad, 0xbe, 0xef];
      };
      const token: string = computeTokenHex('pass', 'salt', fakeMd5);
      expect(captured).assertEqual('passsalt');
      expect(token).assertEqual('deadbeef');
    });

    it('buildAuthQuery_has_u_t_s_v_c_f', 0, () => {
      const q: string = buildAuthQuery('alice', 'tok', 'salt', '1.16.1', 'SoundIsle', 'json');
      expect(q).assertContain('u=alice');
      expect(q).assertContain('t=tok');
      expect(q).assertContain('s=salt');
      expect(q).assertContain('v=1.16.1');
      expect(q).assertContain('c=SoundIsle');
      expect(q).assertContain('f=json');
    });

    it('redactUrl_hides_token_and_salt', 0, () => {
      const url: string = 'http://x/rest/ping.view?u=alice&t=secretToken&s=secretSalt&v=1.16.1&c=SoundIsle&f=json';
      const redacted: string = redactUrl(url);
      expect(redacted.includes('secretToken')).assertFalse();
      expect(redacted.includes('secretSalt')).assertFalse();
      expect(redacted.includes('u=alice')).assertTrue();
      expect(redacted).assertContain('t=REDACTED');
      expect(redacted).assertContain('s=REDACTED');
    });
  });
}
