import { describe, expect, it } from '@ohos/hypium';
import { InMemorySecureStorage } from '../main/ets/infrastructure/storage/InMemoryStorage';
import { SecureStorage } from '../main/ets/infrastructure/storage/StorageContracts';

export default function secureStorageTest() {
  describe('SecureStorage contract', () => {
    it('write_then_read_roundtrips', 0, async () => {
      const s: SecureStorage = new InMemorySecureStorage();
      await s.putSecret('cred_ref_1', 'hunter2');
      expect(await s.contains('cred_ref_1')).assertTrue();
      expect(await s.getSecret('cred_ref_1')).assertEqual('hunter2');
    });

    it('wrong_alias_does_not_return_secret', 0, async () => {
      const s: SecureStorage = new InMemorySecureStorage();
      await s.putSecret('cred_ref_1', 'hunter2');
      expect(await s.contains('cred_ref_2')).assertFalse();
      let threw: boolean = false;
      try {
        await s.getSecret('cred_ref_2');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertTrue();
    });

    it('missing_credential_throws', 0, async () => {
      const s: SecureStorage = new InMemorySecureStorage();
      let threw: boolean = false;
      try {
        await s.getSecret('never_stored');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertTrue();
    });

    it('delete_removes_credential', 0, async () => {
      const s: SecureStorage = new InMemorySecureStorage();
      await s.putSecret('cred_ref_1', 'hunter2');
      await s.deleteSecret('cred_ref_1');
      expect(await s.contains('cred_ref_1')).assertFalse();
      let threw: boolean = false;
      try {
        await s.getSecret('cred_ref_1');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertTrue();
    });

    it('update_overwrites_credential', 0, async () => {
      const s: SecureStorage = new InMemorySecureStorage();
      await s.putSecret('cred_ref_1', 'oldpass');
      await s.putSecret('cred_ref_1', 'newpass');
      expect(await s.getSecret('cred_ref_1')).assertEqual('newpass');
    });
  });
}
