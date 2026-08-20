import { DomainErrorCategory } from '../domain/error/DomainError';
import { ServerConnectionResult, ServerConnectionState } from '../domain/server/ServerConnection';

export interface PingResponseRoot {
  subsonicResponse?: PingSubsonicResponse;
}

export interface PingSubsonicResponse {
  status?: string;
  version?: string;
  type?: string;
  serverVersion?: string;
  openSubsonic?: boolean;
  error?: PingError;
}

export interface PingError {
  code?: number;
  message?: string;
}

// Defensive parse of a ping response (TYPE_SYSTEM_RULES: parse unknown JSON defensively).
export function parsePingResponse(body: string): ServerConnectionResult {
  let root: PingResponseRoot;
  try {
    // The protocol key "subsonic-response" contains a hyphen, which ArkTS cannot access
    // by index; normalize it to a camelCase key before JSON.parse.
    const normalized: string = body.replace('"subsonic-response"', '"subsonicResponse"');
    root = JSON.parse(normalized) as PingResponseRoot;
  } catch (e) {
    return { state: 'INVALID_RESPONSE' };
  }
  const subsonic: PingSubsonicResponse | undefined = root.subsonicResponse;
  if (subsonic === undefined) {
    return { state: 'INVALID_RESPONSE' };
  }
  if (subsonic.status === 'ok') {
    return {
      state: 'CONNECTED',
      apiVersion: subsonic.version,
      serverType: subsonic.type,
      serverVersion: subsonic.serverVersion,
      openSubsonic: subsonic.openSubsonic
    };
  }
  const code: number = subsonic.error === undefined ? 0 : (subsonic.error.code === undefined ? 0 : subsonic.error.code);
  if (code === 30 || code === 40) {
    return { state: 'AUTH_FAILED' };
  }
  return { state: 'SERVER_ERROR' };
}

export function mapErrorCategoryToState(category: DomainErrorCategory): ServerConnectionState {
  if (category === 'AUTHENTICATION') {
    return 'AUTH_FAILED';
  }
  if (category === 'NETWORK_UNAVAILABLE') {
    return 'NETWORK_ERROR';
  }
  if (category === 'TIMEOUT') {
    return 'TIMEOUT';
  }
  if (category === 'TLS') {
    return 'NETWORK_ERROR';
  }
  if (category === 'SERVER_UNAVAILABLE') {
    return 'SERVER_ERROR';
  }
  return 'INVALID_RESPONSE';
}
