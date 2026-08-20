import { MediaKey } from '../domain/model/MediaKey';
import { AudioSource } from '../domain/model/QueueModels';
import { ServerProfile } from '../domain/model/UserModels';
import { ProviderFactory } from '../domain/provider/Provider';
import { ServerRepository } from '../domain/repository/ServerRepository';
import { SecureStorage } from '../infrastructure/storage/StorageContracts';
import { PlaybackResolver } from './PlaybackContracts';

// Resolves a Song MediaKey into a fresh AudioSource by asking the provider for a new
// stream URL. The recovered credential is used only to sign the request; the URL is
// ephemeral (never persisted) per DATA_MODEL/AUDIO_ARCHITECTURE.
export class ProviderPlaybackResolver implements PlaybackResolver {
  private readonly serverRepository: ServerRepository;
  private readonly secureStorage: SecureStorage;
  private readonly providerFactory: ProviderFactory;

  constructor(serverRepository: ServerRepository, secureStorage: SecureStorage, providerFactory: ProviderFactory) {
    this.serverRepository = serverRepository;
    this.secureStorage = secureStorage;
    this.providerFactory = providerFactory;
  }

  async resolve(key: MediaKey): Promise<AudioSource> {
    const profile: ServerProfile = await this.serverRepository.get(key.serverId);
    const password: string = await this.secureStorage.getSecret(profile.credentialRef);
    const username: string = profile.username === undefined ? '' : profile.username;
    return await this.providerFactory.create(profile).resolveAudioSource(username, password, key);
  }
}
