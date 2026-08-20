import { describe, expect, it } from '@ohos/hypium';
import { DomainError } from '../main/ets/domain/error/DomainError';

export default function domainErrorTest() {
  describe('DomainError', () => {
    it('carries_category_and_retryable', 0, () => {
      const err: DomainError = new DomainError('TIMEOUT', 'boom', true, 'cause');
      expect(err.category).assertEqual('TIMEOUT');
      expect(err.retryable).assertTrue();
      expect(err.message).assertEqual('boom');
    });

    it('unsupported_is_not_retryable', 0, () => {
      const err: DomainError = DomainError.unsupported('nope');
      expect(err.category).assertEqual('UNSUPPORTED_CAPABILITY');
      expect(err.retryable).assertFalse();
    });
  });
}
