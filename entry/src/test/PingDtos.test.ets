import { describe, expect, it } from '@ohos/hypium';
import { mapErrorCategoryToState, parsePingResponse } from '../main/ets/providers/PingDtos';

export default function pingDtosTest() {
  describe('parsePingResponse', () => {
    it('parses_successful_response', 0, () => {
      const json: string = '{"subsonic-response":{"status":"ok","version":"1.16.1","type":"navidrome","serverVersion":"0.52.5","openSubsonic":true}}';
      const r = parsePingResponse(json);
      expect(r.state).assertEqual('CONNECTED');
      expect(r.serverType).assertEqual('navidrome');
      expect(r.serverVersion).assertEqual('0.52.5');
      expect(r.apiVersion).assertEqual('1.16.1');
      expect(r.openSubsonic).assertTrue();
    });

    it('maps_failed_code_40_to_auth_failed', 0, () => {
      const json: string = '{"subsonic-response":{"status":"failed","error":{"code":40,"message":"Wrong username or password"}}}';
      expect(parsePingResponse(json).state).assertEqual('AUTH_FAILED');
    });

    it('maps_failed_code_0_to_server_error', 0, () => {
      const json: string = '{"subsonic-response":{"status":"failed","error":{"code":0,"message":"generic"}}}';
      expect(parsePingResponse(json).state).assertEqual('SERVER_ERROR');
    });

    it('invalid_json_to_invalid_response', 0, () => {
      expect(parsePingResponse('not-json').state).assertEqual('INVALID_RESPONSE');
    });

    it('missing_subsonic_response_to_invalid_response', 0, () => {
      expect(parsePingResponse('{"foo":1}').state).assertEqual('INVALID_RESPONSE');
    });
  });

  describe('mapErrorCategoryToState', () => {
    it('maps_categories', 0, () => {
      expect(mapErrorCategoryToState('AUTHENTICATION')).assertEqual('AUTH_FAILED');
      expect(mapErrorCategoryToState('NETWORK_UNAVAILABLE')).assertEqual('NETWORK_ERROR');
      expect(mapErrorCategoryToState('TIMEOUT')).assertEqual('TIMEOUT');
      expect(mapErrorCategoryToState('SERVER_UNAVAILABLE')).assertEqual('SERVER_ERROR');
      expect(mapErrorCategoryToState('INVALID_RESPONSE')).assertEqual('INVALID_RESPONSE');
    });
  });
}
