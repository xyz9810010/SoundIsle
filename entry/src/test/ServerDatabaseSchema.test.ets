import { describe, expect, it } from '@ohos/hypium';
import { DomainError } from '../main/ets/domain/error/DomainError';
import { CREATE_SERVERS_TABLE_SQL, ensureServerSchema, mapDatabaseError, SERVER_SCHEMA_VERSION } from '../main/ets/data/persistence/ServerDatabaseSchema';
import { FakeRdbStore } from './FakeRdbStore';

export default function serverDatabaseSchemaTest() {
  describe('ServerDatabaseSchema', () => {
    it('create_table_has_expected_columns', 0, () => {
      expect(CREATE_SERVERS_TABLE_SQL).assertContain('id TEXT PRIMARY KEY');
      expect(CREATE_SERVERS_TABLE_SQL).assertContain('name TEXT NOT NULL');
      expect(CREATE_SERVERS_TABLE_SQL).assertContain('provider_type TEXT NOT NULL');
      expect(CREATE_SERVERS_TABLE_SQL).assertContain('primary_url TEXT NOT NULL');
      expect(CREATE_SERVERS_TABLE_SQL).assertContain('credential_ref TEXT NOT NULL');
    });

    it('create_table_has_no_secret_column', 0, () => {
      const lower: string = CREATE_SERVERS_TABLE_SQL.toLowerCase();
      expect(lower.includes('password')).assertFalse();
      expect(lower.includes('token')).assertFalse();
      expect(lower.includes('secret')).assertFalse();
      expect(lower.includes('api_key')).assertFalse();
    });

    it('schema_version_is_1', 0, () => {
      expect(SERVER_SCHEMA_VERSION).assertEqual(1);
    });

    it('ensureSchema_sets_version_1_and_is_idempotent', 0, async () => {
      const fake: FakeRdbStore = new FakeRdbStore();
      await ensureServerSchema(fake);
      expect(await fake.getSchemaVersion()).assertEqual(1);
      await ensureServerSchema(fake);
      expect(await fake.getSchemaVersion()).assertEqual(1);
    });

    it('ensureSchema_rejects_newer_version', 0, async () => {
      const fake: FakeRdbStore = new FakeRdbStore();
      await fake.setSchemaVersion(2);
      let threw: boolean = false;
      let category: string = '';
      try {
        await ensureServerSchema(fake);
      } catch (e) {
        threw = true;
        if (e instanceof DomainError) {
          category = e.category;
        }
      }
      expect(threw).assertTrue();
      expect(category).assertEqual('DATABASE');
    });

    it('mapDatabaseError_uses_database_category', 0, () => {
      expect(mapDatabaseError('boom').category).assertEqual('DATABASE');
    });
  });
}
