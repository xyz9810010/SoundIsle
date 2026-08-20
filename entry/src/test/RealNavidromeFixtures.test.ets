import { describe, expect, it } from '@ohos/hypium';
import { parsePingResponse } from '../main/ets/providers/PingDtos';
import { parseSubsonicResponse } from '../main/ets/providers/OpenSubsonicMappers';
import { DomainError } from '../main/ets/domain/error/DomainError';

// Captured verbatim from the real Navidrome (0.61.2) with a bogus auth token.
const REAL_BOGUS_AUTH_JSON: string =
  '{"subsonic-response":{"status":"failed","version":"1.16.1","type":"navidrome","serverVersion":"0.61.2 (aa84e645)","openSubsonic":true,"error":{"code":40,"message":"Wrong username or password"}}}';

// Real "ok" shape derived from the server's actual fields (same envelope as the failed response).
const REAL_OK_JSON: string =
  '{"subsonic-response":{"status":"ok","version":"1.16.1","type":"navidrome","serverVersion":"0.61.2 (aa84e645)","openSubsonic":true}}';

export default function realNavidromeFixturesTest() {
  describe('real Navidrome response format', () => {
    it('bogus_auth_maps_to_auth_failed', 0, () => {
      const r = parsePingResponse(REAL_BOGUS_AUTH_JSON);
      expect(r.state).assertEqual('AUTH_FAILED');
    });

    it('ok_shape_maps_to_connected_with_identity', 0, () => {
      const r = parsePingResponse(REAL_OK_JSON);
      expect(r.state).assertEqual('CONNECTED');
      expect(r.serverType).assertEqual('navidrome');
      expect(r.serverVersion).assertEqual('0.61.2 (aa84e645)');
      expect(r.apiVersion).assertEqual('1.16.1');
      expect(r.openSubsonic).assertTrue();
    });

    it('envelope_parses_with_real_fields', 0, () => {
      const dto = parseSubsonicResponse(REAL_OK_JSON);
      expect(dto.type).assertEqual('navidrome');
      expect(dto.serverVersion).assertEqual('0.61.2 (aa84e645)');
      expect(dto.openSubsonic).assertTrue();
    });
  });
}
