import { ServerProfile } from '../model/UserModels';
import { ServerRepository } from '../repository/ServerRepository';
import { SecureStorage } from '../../infrastructure/storage/StorageContracts';
import { normalizeBaseUrl } from '../url/ServerUrl';
import { AddServerInput, AddServerResult, ServerConnectionResult, ServerPinger, ServerPingerFactory } from './ServerConnection';

function generateServerId(): string {
  return 'srv_' + Date.now().toString(36) + '_' + Math.floor(Math.random() * 1000000).toString(36);
}

function credentialRefFor(serverId: string): string {
  return 'server_credential_' + serverId;
}

// Application-level server connection use case (SERVER_CONNECTION_FLOW.md +
// CREDENTIAL_COMPENSATION.md). Credentials live only in SecureStorage; RDB stores only
// the credential_ref. A failed durable save compensates by deleting the new credential.
export class ServerConnectionFlow {
  private readonly pingerFactory: ServerPingerFactory;
  private readonly secureStorage: SecureStorage;
  private readonly serverRepository: ServerRepository;

  constructor(pingerFactory: ServerPingerFactory, secureStorage: SecureStorage, serverRepository: ServerRepository) {
    this.pingerFactory = pingerFactory;
    this.secureStorage = secureStorage;
    this.serverRepository = serverRepository;
  }

  // Restore path: list durable server profiles (name/url/username/credential_ref).
  async listServers(): Promise<ServerProfile[]> {
    return await this.serverRepository.list();
  }

  // Verify the credential referenced by a profile is still recoverable.
  async hasCredential(profile: ServerProfile): Promise<boolean> {
    return await this.secureStorage.contains(profile.credentialRef);
  }

  // Ephemeral connection probe (no persistence).
  async connect(input: AddServerInput): Promise<ServerConnectionResult> {
    const normalizedUrl: string = normalizeBaseUrl(input.url);
    const profile: ServerProfile = this.buildProfile(input, normalizedUrl, 'temporary', 'temporary');
    const pinger: ServerPinger = this.pingerFactory.createPinger(profile);
    return await pinger.ping(input.username, input.password);
  }

  // Reconnect using the DURABLE credential: read profile from RDB, recover the secret
  // from SecureStorage via credential_ref, then ping. Does NOT require the user to
  // re-enter the password, and never persists the recovered secret anywhere.
  async reconnectServer(serverId: string): Promise<ServerConnectionResult> {
    const profile: ServerProfile = await this.serverRepository.get(serverId);
    const password: string = await this.secureStorage.getSecret(profile.credentialRef);
    const pinger: ServerPinger = this.pingerFactory.createPinger(profile);
    const username: string = profile.username === undefined ? '' : profile.username;
    return await pinger.ping(username, password);
  }

  // Full add-server flow: ping -> credential -> durable profile (with compensation).
  async addServer(input: AddServerInput): Promise<AddServerResult> {
    const normalizedUrl: string = normalizeBaseUrl(input.url);
    const serverId: string = generateServerId();
    const credentialRef: string = credentialRefFor(serverId);
    const profile: ServerProfile = this.buildProfile(input, normalizedUrl, serverId, credentialRef);

    const pinger: ServerPinger = this.pingerFactory.createPinger(profile);
    const pingResult: ServerConnectionResult = await pinger.ping(input.username, input.password);
    if (pingResult.state !== 'CONNECTED') {
      return { state: pingResult.state };
    }

    await this.secureStorage.putSecret(credentialRef, input.password);

    try {
      await this.serverRepository.create(profile);
    } catch (e) {
      // Compensation: never leave an orphan credential.
      await this.secureStorage.deleteSecret(credentialRef);
      return { state: 'INVALID_RESPONSE', errorMessage: 'save failed' };
    }
    return { state: 'CONNECTED', profile: profile };
  }

  // Remove server: delete durable profile first, then the credential it referenced.
  async removeServer(serverId: string): Promise<void> {
    const profile: ServerProfile = await this.serverRepository.get(serverId);
    await this.serverRepository.remove(serverId);
    await this.secureStorage.deleteSecret(profile.credentialRef);
  }

  private buildProfile(input: AddServerInput, normalizedUrl: string, serverId: string, credentialRef: string): ServerProfile {
    const now: number = Date.now();
    return {
      id: serverId,
      name: input.name,
      providerType: 'OPENSUBSONIC',
      primaryUrl: normalizedUrl,
      alternativeUrls: [],
      username: input.username,
      credentialRef: credentialRef,
      enabled: true,
      createdAtMs: now,
      updatedAtMs: now
    };
  }
}
