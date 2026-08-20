import { describe, expect, it } from '@ohos/hypium';
import { ProviderPlaybackResolver } from '../main/ets/playback/ProviderPlaybackResolver';
import { MediaKey, makeMediaKey } from '../main/ets/domain/model/MediaKey';
import { AudioSource } from '../main/ets/domain/model/QueueModels';
import { ServerProfile } from '../main/ets/domain/model/UserModels';
import { Provider, ProviderCapabilities, ProviderFactory, emptyCapabilities } from '../main/ets/domain/provider/Provider';
import { ServerRepository } from '../main/ets/domain/repository/ServerRepository';
import { ServerConnectionResult } from '../main/ets/domain/server/ServerConnection';
import { Album, Artist, Song } from '../main/ets/domain/model/MediaModels';
import { Page } from '../main/ets/domain/Page';
import { SecureStorage } from '../main/ets/infrastructure/storage/StorageContracts';

class FakeProvider implements Provider {
  profile: ServerProfile;
  capabilities: ProviderCapabilities = emptyCapabilities();
  lastUsername: string = '';
  lastPassword: string = '';
  lastKey: MediaKey | undefined = undefined;

  constructor(profile: ServerProfile) {
    this.profile = profile;
  }

  async resolveAudioSource(username: string, password: string, key: MediaKey): Promise<AudioSource> {
    this.lastUsername = username;
    this.lastPassword = password;
    this.lastKey = key;
    return { mediaKey: key, uri: 'http://srv/rest/stream?id=' + key.remoteId, routeId: this.profile.primaryUrl, sourceType: 'REMOTE_ORIGINAL' };
  }

  async ping(username: string, password: string): Promise<ServerConnectionResult> {
    return { state: 'CONNECTED' };
  }
  async listArtists(username: string, password: string, offset: number, size: number): Promise<Page<Artist>> {
    return { items: [], hasMore: false };
  }
  async listAlbums(username: string, password: string, offset: number, size: number): Promise<Page<Album>> {
    return { items: [], hasMore: false };
  }
  async search(username: string, password: string, query: string, offset: number, size: number): Promise<Page<Song>> {
    return { items: [], hasMore: false };
  }
  async discoverCapabilities(username: string, password: string): Promise<ProviderCapabilities> {
    return emptyCapabilities();
  }
  getCoverArtUrl(coverArtId: string): string {
    return '';
  }
}

class FakeProviderFactory implements ProviderFactory {
  private provider: FakeProvider | undefined = undefined;
  setProvider(p: FakeProvider): void {
    this.provider = p;
  }
  create(profile: ServerProfile): Provider {
    if (this.provider === undefined) {
      this.provider = new FakeProvider(profile);
    }
    return this.provider;
  }
}

class FakeServerRepository implements ServerRepository {
  private servers: Map<string, ServerProfile> = new Map<string, ServerProfile>();
  async list(): Promise<ServerProfile[]> {
    const r: ServerProfile[] = [];
    this.servers.forEach((v: ServerProfile): void => { r.push(v); });
    return r;
  }
  async get(id: string): Promise<ServerProfile> {
    const s = this.servers.get(id);
    if (s === undefined) { throw new Error('not found'); }
    return s;
  }
  async create(p: ServerProfile): Promise<void> { this.servers.set(p.id, p); }
  async update(p: ServerProfile): Promise<void> { this.servers.set(p.id, p); }
  async remove(id: string): Promise<void> { this.servers.delete(id); }
}

class FakeSecureStorage implements SecureStorage {
  private m: Map<string, string> = new Map<string, string>();
  async putSecret(k: string, v: string): Promise<void> { this.m.set(k, v); }
  async getSecret(k: string): Promise<string> {
    const v = this.m.get(k);
    if (v === undefined) { throw new Error('missing'); }
    return v;
  }
  async deleteSecret(k: string): Promise<void> { this.m.delete(k); }
  async contains(k: string): Promise<boolean> { return this.m.has(k); }
}

export default function providerPlaybackResolverTest() {
  describe('ProviderPlaybackResolver', () => {
    it('resolves_audio_source_with_server_scoped_credentials', 0, async () => {
      const repo: FakeServerRepository = new FakeServerRepository();
      const profile: ServerProfile = {
        id: 'srv1', name: 'N', providerType: 'OPENSUBSONIC', primaryUrl: 'http://srv',
        alternativeUrls: [], credentialRef: 'cred1', enabled: true, createdAtMs: 1, updatedAtMs: 1
      };
      await repo.create(profile);
      const secure: FakeSecureStorage = new FakeSecureStorage();
      await secure.putSecret('cred1', 's3cr3t');
      const factory: FakeProviderFactory = new FakeProviderFactory();
      const resolver: ProviderPlaybackResolver = new ProviderPlaybackResolver(repo, secure, factory);

      const key: MediaKey = makeMediaKey('OPENSUBSONIC', 'srv1', 'SONG', 'song-1');
      const source: AudioSource = await resolver.resolve(key);

      expect(source.mediaKey.remoteId).assertEqual('song-1');
      expect(source.uri).assertContain('id=song-1');
      expect(source.sourceType).assertEqual('REMOTE_ORIGINAL');
      expect(source.routeId).assertEqual('http://srv');
    });
  });
}
