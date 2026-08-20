import { describe, expect, it } from '@ohos/hypium';
import { profileToRow, rowToProfile, ServerRow } from '../main/ets/data/ServerProfileMapper';
import { ServerProfile } from '../main/ets/domain/model/UserModels';
import { RdbResultSet } from '../main/ets/infrastructure/storage/StorageContracts';
import { FakeResultSet } from './FakeRdbStore';

function singleRow(row: ServerRow): RdbResultSet {
  const m: Array<Map<string, string | number>> = [];
  const map: Map<string, string | number> = new Map<string, string | number>();
  map.set('id', row.id);
  map.set('name', row.name);
  map.set('provider_type', row.providerType);
  map.set('primary_url', row.primaryUrl);
  map.set('lan_url', row.lanUrl);
  map.set('alternative_urls_json', row.alternativeUrlsJson);
  map.set('username', row.username);
  map.set('credential_ref', row.credentialRef);
  map.set('enabled', row.enabled);
  map.set('created_at_ms', row.createdAtMs);
  map.set('updated_at_ms', row.updatedAtMs);
  m.push(map);
  return new FakeResultSet(m);
}

export default function serverProfileMapperTest() {
  describe('ServerProfileMapper', () => {
    it('roundtrips_profile_to_row_and_back', 0, () => {
      const profile: ServerProfile = {
        id: 'srv1',
        name: 'Home Navidrome',
        providerType: 'OPENSUBSONIC',
        primaryUrl: 'https://music.example.com/music',
        lanUrl: 'http://192.168.1.5:4533',
        alternativeUrls: ['http://192.168.1.5:4533'],
        username: 'alice',
        credentialRef: 'asset://cred1',
        enabled: true,
        createdAtMs: 1000,
        updatedAtMs: 2000
      };
      const restored: ServerProfile = rowToProfile(singleRow(profileToRow(profile)), 0);
      expect(restored.id).assertEqual('srv1');
      expect(restored.name).assertEqual('Home Navidrome');
      expect(restored.providerType).assertEqual('OPENSUBSONIC');
      expect(restored.primaryUrl).assertEqual('https://music.example.com/music');
      expect(restored.credentialRef).assertEqual('asset://cred1');
      expect(restored.enabled).assertTrue();
      expect(restored.alternativeUrls.length).assertEqual(1);
      expect(restored.lanUrl).assertEqual('http://192.168.1.5:4533');
      expect(restored.username).assertEqual('alice');
      expect(restored.createdAtMs).assertEqual(1000);
    });

    it('preserves_credential_ref_only_no_secret_field', 0, () => {
      const profile: ServerProfile = {
        id: 'srv1',
        name: 'N',
        providerType: 'OPENSUBSONIC',
        primaryUrl: 'http://x',
        alternativeUrls: [],
        credentialRef: 'asset://cred1',
        enabled: true,
        createdAtMs: 1,
        updatedAtMs: 1
      };
      const json: string = JSON.stringify(profileToRow(profile));
      expect(json).assertContain('credentialRef');
      expect(json.includes('password')).assertFalse();
      expect(json.includes('token')).assertFalse();
      expect(json.includes('secret')).assertFalse();
    });
  });
}
