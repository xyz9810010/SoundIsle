import { describe, expect, it } from '@ohos/hypium';
import { ServerConnectionFlow } from '../main/ets/domain/server/ServerConnectionFlow';
import { AddServerInput, ServerConnectionResult, ServerPinger, ServerPingerFactory } from '../main/ets/domain/server/ServerConnection';
import { ServerProfile } from '../main/ets/domain/model/UserModels';
import { ServerRepository } from '../main/ets/domain/repository/ServerRepository';
import { SecureStorage } from '../main/ets/infrastructure/storage/StorageContracts';

class FakeServerPinger implements ServerPinger {
  result: ServerConnectionResult = { state: 'CONNECTED' };
  lastPassword: string = '';
  async ping(username: string, password: string): Promise<ServerConnectionResult> {
    this.lastPassword = password;
    return this.result;
  }
}

class FakeServerPingerFactory implements ServerPingerFactory {
  pinger: ServerPinger = new FakeServerPinger();
  createPinger(profile: ServerProfile): ServerPinger {
    return this.pinger;
  }
}

class RecordingSecureStorage implements SecureStorage {
  private readonly secrets: Map<string, string> = new Map<string, string>();
  readonly putKeys: string[] = [];
  readonly deleteKeys: string[] = [];

  async putSecret(key: string, secret: string): Promise<void> {
    this.putKeys.push(key);
    this.secrets.set(key, secret);
  }

  async getSecret(key: string): Promise<string> {
    const v: string | undefined = this.secrets.get(key);
    if (v === undefined) {
      throw new Error('Secret not found: ' + key);
    }
    return v;
  }

  async deleteSecret(key: string): Promise<void> {
    this.deleteKeys.push(key);
    this.secrets.delete(key);
  }

  async contains(key: string): Promise<boolean> {
    return this.secrets.has(key);
  }
}

class FakeServerRepository implements ServerRepository {
  private servers: Map<string, ServerProfile> = new Map<string, ServerProfile>();
  failCreate: boolean = false;

  async list(): Promise<ServerProfile[]> {
    const result: ServerProfile[] = [];
    this.servers.forEach((v: ServerProfile): void => {
      result.push(v);
    });
    return result;
  }

  async get(id: string): Promise<ServerProfile> {
    const s: ServerProfile | undefined = this.servers.get(id);
    if (s === undefined) {
      throw new Error('not found');
    }
    return s;
  }

  async create(profile: ServerProfile): Promise<void> {
    if (this.failCreate) {
      throw new Error('db write failed');
    }
    this.servers.set(profile.id, profile);
  }

  async update(profile: ServerProfile): Promise<void> {
    this.servers.set(profile.id, profile);
  }

  async remove(id: string): Promise<void> {
    this.servers.delete(id);
  }
}

function input(): AddServerInput {
  return { name: 'Home', url: 'https://music.example.com/music/', username: 'alice', password: 's3cr3t' };
}

export default function serverConnectionFlowTest() {
  describe('ServerConnectionFlow.addServer', () => {
    it('success_persists_profile_and_credential', 0, async () => {
      const pinger: FakeServerPinger = new FakeServerPinger();
      pinger.result = { state: 'CONNECTED', serverType: 'navidrome' };
      const factory: FakeServerPingerFactory = new FakeServerPingerFactory();
      factory.pinger = pinger;
      const secure: RecordingSecureStorage = new RecordingSecureStorage();
      const repo: FakeServerRepository = new FakeServerRepository();
      const flow: ServerConnectionFlow = new ServerConnectionFlow(factory, secure, repo);

      const result = await flow.addServer(input());
      expect(result.state).assertEqual('CONNECTED');
      expect(result.profile !== undefined).assertTrue();
      expect(secure.putKeys.length).assertEqual(1);
      expect(await secure.contains(secure.putKeys[0])).assertTrue();
      expect(await secure.getSecret(secure.putKeys[0])).assertEqual('s3cr3t');
      expect((await repo.list()).length).assertEqual(1);
    });

    it('auth_failure_does_not_persist', 0, async () => {
      const pinger: FakeServerPinger = new FakeServerPinger();
      pinger.result = { state: 'AUTH_FAILED' };
      const factory: FakeServerPingerFactory = new FakeServerPingerFactory();
      factory.pinger = pinger;
      const secure: RecordingSecureStorage = new RecordingSecureStorage();
      const repo: FakeServerRepository = new FakeServerRepository();
      const flow: ServerConnectionFlow = new ServerConnectionFlow(factory, secure, repo);

      const result = await flow.addServer(input());
      expect(result.state).assertEqual('AUTH_FAILED');
      expect(secure.putKeys.length).assertEqual(0);
      expect((await repo.list()).length).assertEqual(0);
    });

    it('db_failure_compensates_and_deletes_credential', 0, async () => {
      const pinger: FakeServerPinger = new FakeServerPinger();
      pinger.result = { state: 'CONNECTED' };
      const factory: FakeServerPingerFactory = new FakeServerPingerFactory();
      factory.pinger = pinger;
      const secure: RecordingSecureStorage = new RecordingSecureStorage();
      const repo: FakeServerRepository = new FakeServerRepository();
      repo.failCreate = true;
      const flow: ServerConnectionFlow = new ServerConnectionFlow(factory, secure, repo);

      const result = await flow.addServer(input());
      expect(result.state).assertEqual('INVALID_RESPONSE');
      expect((await repo.list()).length).assertEqual(0);
      // compensation: credential written then deleted (no orphan)
      expect(secure.putKeys.length).assertEqual(1);
      expect(secure.deleteKeys.length).assertEqual(1);
      expect(secure.deleteKeys[0]).assertEqual(secure.putKeys[0]);
      expect(await secure.contains(secure.putKeys[0])).assertFalse();
    });
  });

  describe('ServerConnectionFlow.listServers (restore path)', () => {
    it('saved_profile_is_restored', 0, async () => {
      const pinger: FakeServerPinger = new FakeServerPinger();
      const factory: FakeServerPingerFactory = new FakeServerPingerFactory();
      factory.pinger = pinger;
      const secure: RecordingSecureStorage = new RecordingSecureStorage();
      const repo: FakeServerRepository = new FakeServerRepository();
      const flow: ServerConnectionFlow = new ServerConnectionFlow(factory, secure, repo);

      const added = await flow.addServer(input());
      const servers = await flow.listServers();
      expect(servers.length).assertEqual(1);
      expect(servers[0].name).assertEqual('Home');
      expect(servers[0].primaryUrl).assertEqual('https://music.example.com/music');
      expect(servers[0].username).assertEqual('alice');
      expect(added.profile !== undefined).assertTrue();
      if (added.profile !== undefined) {
        expect(servers[0].credentialRef).assertEqual(added.profile.credentialRef);
        expect(await flow.hasCredential(servers[0])).assertTrue();
      }
    });
  });

  describe('ServerConnectionFlow.reconnectServer', () => {
    it('recovers_credential_from_secure_storage', 0, async () => {
      const pinger: FakeServerPinger = new FakeServerPinger();
      const factory: FakeServerPingerFactory = new FakeServerPingerFactory();
      factory.pinger = pinger;
      const secure: RecordingSecureStorage = new RecordingSecureStorage();
      const repo: FakeServerRepository = new FakeServerRepository();
      const flow: ServerConnectionFlow = new ServerConnectionFlow(factory, secure, repo);

      const added = await flow.addServer(input());
      const id: string = added.profile === undefined ? '' : added.profile.id;
      // simulate restart: new flow over the SAME durable stores
      const restartedFlow: ServerConnectionFlow = new ServerConnectionFlow(factory, secure, repo);
      const result = await restartedFlow.reconnectServer(id);
      expect(result.state).assertEqual('CONNECTED');
      expect(pinger.lastPassword).assertEqual('s3cr3t');
    });

    it('missing_credential_throws', 0, async () => {
      const pinger: FakeServerPinger = new FakeServerPinger();
      const factory: FakeServerPingerFactory = new FakeServerPingerFactory();
      factory.pinger = pinger;
      const secure: RecordingSecureStorage = new RecordingSecureStorage();
      const repo: FakeServerRepository = new FakeServerRepository();
      const flow: ServerConnectionFlow = new ServerConnectionFlow(factory, secure, repo);

      const added = await flow.addServer(input());
      const id: string = added.profile === undefined ? '' : added.profile.id;
      if (added.profile !== undefined) {
        await secure.deleteSecret(added.profile.credentialRef);
      }
      let threw: boolean = false;
      try {
        await flow.reconnectServer(id);
      } catch (e) {
        threw = true;
      }
      expect(threw).assertTrue();
    });
  });

  describe('ServerConnectionFlow.removeServer', () => {
    it('removes_profile_then_credential', 0, async () => {
      const pinger: FakeServerPinger = new FakeServerPinger();
      const factory: FakeServerPingerFactory = new FakeServerPingerFactory();
      factory.pinger = pinger;
      const secure: RecordingSecureStorage = new RecordingSecureStorage();
      const repo: FakeServerRepository = new FakeServerRepository();
      const flow: ServerConnectionFlow = new ServerConnectionFlow(factory, secure, repo);

      const added = await flow.addServer(input());
      expect(added.profile !== undefined).assertTrue();
      if (added.profile !== undefined) {
        await flow.removeServer(added.profile.id);
      }
      expect((await repo.list()).length).assertEqual(0);
      expect(secure.deleteKeys.length).assertEqual(1);
    });
  });
}
