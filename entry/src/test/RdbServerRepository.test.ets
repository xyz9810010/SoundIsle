import { describe, expect, it } from '@ohos/hypium';
import { RdbServerRepository } from '../main/ets/data/RdbServerRepository';
import { ServerProfile } from '../main/ets/domain/model/UserModels';
import { FakeRdbStore } from './FakeRdbStore';

function makeProfile(id: string, name: string): ServerProfile {
  return {
    id: id,
    name: name,
    providerType: 'OPENSUBSONIC',
    primaryUrl: 'https://music.example.com/music',
    alternativeUrls: [],
    credentialRef: 'asset://cred1',
    enabled: true,
    createdAtMs: 1000,
    updatedAtMs: 1000
  };
}

export default function rdbServerRepositoryTest() {
  describe('RdbServerRepository', () => {
    it('create_then_list_and_get', 0, async () => {
      const repo: RdbServerRepository = new RdbServerRepository(new FakeRdbStore());
      await repo.create(makeProfile('srv1', 'Home'));
      const list = await repo.list();
      expect(list.length).assertEqual(1);
      const got = await repo.get('srv1');
      expect(got.name).assertEqual('Home');
    });

    it('credential_ref_roundtrips', 0, async () => {
      const repo: RdbServerRepository = new RdbServerRepository(new FakeRdbStore());
      await repo.create(makeProfile('srv1', 'Home'));
      expect((await repo.get('srv1')).credentialRef).assertEqual('asset://cred1');
    });

    it('update_changes_name', 0, async () => {
      const repo: RdbServerRepository = new RdbServerRepository(new FakeRdbStore());
      await repo.create(makeProfile('srv1', 'Old'));
      await repo.update(makeProfile('srv1', 'New'));
      expect((await repo.get('srv1')).name).assertEqual('New');
    });

    it('remove_deletes_row', 0, async () => {
      const repo: RdbServerRepository = new RdbServerRepository(new FakeRdbStore());
      await repo.create(makeProfile('srv1', 'Home'));
      await repo.remove('srv1');
      expect((await repo.list()).length).assertEqual(0);
    });

    it('create_duplicate_throws', 0, async () => {
      const repo: RdbServerRepository = new RdbServerRepository(new FakeRdbStore());
      await repo.create(makeProfile('srv1', 'Home'));
      let threw: boolean = false;
      try {
        await repo.create(makeProfile('srv1', 'Dup'));
      } catch (e) {
        threw = true;
      }
      expect(threw).assertTrue();
    });

    it('update_missing_throws', 0, async () => {
      const repo: RdbServerRepository = new RdbServerRepository(new FakeRdbStore());
      let threw: boolean = false;
      try {
        await repo.update(makeProfile('nope', 'X'));
      } catch (e) {
        threw = true;
      }
      expect(threw).assertTrue();
    });

    it('get_missing_throws', 0, async () => {
      const repo: RdbServerRepository = new RdbServerRepository(new FakeRdbStore());
      let threw: boolean = false;
      try {
        await repo.get('nope');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertTrue();
    });

    it('migrates_schema_on_first_use', 0, async () => {
      const fake: FakeRdbStore = new FakeRdbStore();
      const repo: RdbServerRepository = new RdbServerRepository(fake);
      await repo.create(makeProfile('srv1', 'Home'));
      expect(await fake.getSchemaVersion()).assertEqual(1);
    });
  });
}
