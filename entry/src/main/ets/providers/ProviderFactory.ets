import { DomainError } from '../domain/error/DomainError';
import { ServerProfile } from '../domain/model/UserModels';
import { ServerPinger, ServerPingerFactory } from '../domain/server/ServerConnection';
import { Provider, ProviderFactory as ProviderFactoryContract } from '../domain/provider/Provider';
import { NetworkClient } from '../infrastructure/NetworkClient';
import { OpenSubsonicProvider } from './OpenSubsonicProvider';

export class ProviderFactory implements ServerPingerFactory, ProviderFactoryContract {
  private readonly networkClient: NetworkClient;

  constructor(networkClient: NetworkClient) {
    this.networkClient = networkClient;
  }

  create(profile: ServerProfile): Provider {
    if (profile.providerType === 'OPENSUBSONIC') {
      return new OpenSubsonicProvider(profile, this.networkClient);
    }
    throw DomainError.unsupported('Unsupported provider type: ' + profile.providerType);
  }

  createPinger(profile: ServerProfile): ServerPinger {
    return this.create(profile);
  }
}
