import { ServerProfile } from '../model/UserModels';

export type ServerConnectionState =
  'CONNECTING' | 'CONNECTED' | 'AUTH_FAILED' | 'NETWORK_ERROR' | 'TIMEOUT' | 'SERVER_ERROR' | 'INVALID_RESPONSE';

export interface ServerConnectionResult {
  readonly state: ServerConnectionState;
  readonly serverType?: string;
  readonly serverVersion?: string;
  readonly apiVersion?: string;
  readonly openSubsonic?: boolean;
}

export interface AddServerInput {
  readonly name: string;
  readonly url: string;
  readonly username: string;
  readonly password: string;
}

export interface AddServerResult {
  readonly state: ServerConnectionState;
  readonly profile?: ServerProfile;
  readonly errorMessage?: string;
}

// Ephemeral connection probe (does not persist). Implemented by the provider.
export interface ServerPinger {
  ping(username: string, password: string): Promise<ServerConnectionResult>;
}

export interface ServerPingerFactory {
  createPinger(profile: ServerProfile): ServerPinger;
}
