import { describe, expect, it } from '@ohos/hypium';
import { isHttpSuccess, mapHttpStatusToError, mapNetworkExceptionToError } from '../main/ets/infrastructure/NetworkErrorMapping';

export default function networkErrorMappingTest() {
  describe('NetworkErrorMapping', () => {
    it('maps_401_to_authentication', 0, () => {
      expect(mapHttpStatusToError(401).category).assertEqual('AUTHENTICATION');
    });

    it('maps_403_to_permission_denied', 0, () => {
      expect(mapHttpStatusToError(403).category).assertEqual('PERMISSION_DENIED');
    });

    it('maps_5xx_to_server_unavailable', 0, () => {
      expect(mapHttpStatusToError(503).category).assertEqual('SERVER_UNAVAILABLE');
    });

    it('maps_timeout_exception', 0, () => {
      expect(mapNetworkExceptionToError('Connection timed out').category).assertEqual('TIMEOUT');
    });

    it('maps_tls_exception', 0, () => {
      expect(mapNetworkExceptionToError('SSL certificate verify failed').category).assertEqual('TLS');
    });

    it('maps_generic_exception_to_network_unavailable', 0, () => {
      expect(mapNetworkExceptionToError('ECONNREFUSED').category).assertEqual('NETWORK_UNAVAILABLE');
    });

    it('isHttpSuccess_2xx_only', 0, () => {
      expect(isHttpSuccess(200)).assertTrue();
      expect(isHttpSuccess(204)).assertTrue();
      expect(isHttpSuccess(301)).assertFalse();
      expect(isHttpSuccess(404)).assertFalse();
      expect(isHttpSuccess(500)).assertFalse();
    });
  });
}
