import { Album, Artist, Song } from '../model/MediaModels';
import { Page } from '../Page';
import { ServerProfile } from '../model/UserModels';
import { Provider, ProviderFactory } from '../provider/Provider';
import { ServerRepository } from '../repository/ServerRepository';
import { SecureStorage } from '../../infrastructure/storage/StorageContracts';

interface BrowseContext {
  provider: Provider;
  username: string;
  password: string;
}

// Browse/search use case: loads the durable server profile + its credential, then
// reads through the provider. The recovered password is used only to compute the
// per-request auth token and is never persisted or logged.
export class BrowseService {
  private readonly serverRepository: ServerRepository;
  private readonly secureStorage: SecureStorage;
  private readonly providerFactory: ProviderFactory;

  constructor(serverRepository: ServerRepository, secureStorage: SecureStorage, providerFactory: ProviderFactory) {
    this.serverRepository = serverRepository;
    this.secureStorage = secureStorage;
    this.providerFactory = providerFactory;
  }

  async listArtists(offset: number, size: number): Promise<Page<Artist>> {
    const ctx: BrowseContext = await this.context();
    return await ctx.provider.listArtists(ctx.username, ctx.password, offset, size);
  }

  async listAlbums(offset: number, size: number): Promise<Page<Album>> {
    const ctx: BrowseContext = await this.context();
    return await ctx.provider.listAlbums(ctx.username, ctx.password, offset, size);
  }

  async search(query: string, offset: number, size: number): Promise<Page<Song>> {
    const ctx: BrowseContext = await this.context();
    return await ctx.provider.search(ctx.username, ctx.password, query, offset, size);
  }

  private async context(): Promise<BrowseContext> {
    const servers: ServerProfile[] = await this.serverRepository.list();
    if (servers.length === 0) {
      throw new Error('No server configured');
    }
    const profile: ServerProfile = servers[0];
    const password: string = await this.secureStorage.getSecret(profile.credentialRef);
    const provider: Provider = this.providerFactory.create(profile);
    const username: string = profile.username === undefined ? '' : profile.username;
    return { provider: provider, username: username, password: password };
  }
}
