import { ProviderType } from '../domain/model/StateTypes';
import { ServerProfile } from '../domain/model/UserModels';
import { RdbResultSet } from '../infrastructure/storage/StorageContracts';

const PROVIDER_TYPES: ProviderType[] = ['OPENSUBSONIC', 'JELLYFIN', 'EMBY', 'AUDIO_STATION', 'PLEX'];

export interface ServerRow {
  id: string;
  name: string;
  providerType: ProviderType;
  primaryUrl: string;
  lanUrl: string;
  alternativeUrlsJson: string;
  username: string;
  credentialRef: string;
  enabled: number;
  createdAtMs: number;
  updatedAtMs: number;
}

export function parseProviderType(raw: string): ProviderType {
  for (let i = 0; i < PROVIDER_TYPES.length; i++) {
    if (PROVIDER_TYPES[i] === raw) {
      return PROVIDER_TYPES[i];
    }
  }
  throw new Error('Unknown provider type: ' + raw);
}

// Defensive JSON array parse (TYPE_SYSTEM_RULES: parse unknown JSON defensively).
export function parseStringArray(json: string): string[] {
  if (json === '') {
    return [];
  }
  try {
    const parsed = JSON.parse(json) as string[];
    const result: string[] = [];
    if (parsed !== null && parsed !== undefined) {
      for (let i = 0; i < parsed.length; i++) {
        if (typeof parsed[i] === 'string') {
          result.push(parsed[i]);
        }
      }
    }
    return result;
  } catch (e) {
    return [];
  }
}

export function stringArrayToJson(values: string[]): string {
  return JSON.stringify(values);
}

export function profileToRow(profile: ServerProfile): ServerRow {
  return {
    id: profile.id,
    name: profile.name,
    providerType: profile.providerType,
    primaryUrl: profile.primaryUrl,
    lanUrl: profile.lanUrl === undefined ? '' : profile.lanUrl,
    alternativeUrlsJson: stringArrayToJson(profile.alternativeUrls),
    username: profile.username === undefined ? '' : profile.username,
    credentialRef: profile.credentialRef,
    enabled: profile.enabled ? 1 : 0,
    createdAtMs: profile.createdAtMs,
    updatedAtMs: profile.updatedAtMs
  };
}

export function rowToProfile(resultSet: RdbResultSet, rowIndex: number): ServerProfile {
  const lanUrlRaw: string = resultSet.getString(rowIndex, 'lan_url');
  const usernameRaw: string = resultSet.getString(rowIndex, 'username');
  return {
    id: resultSet.getString(rowIndex, 'id'),
    name: resultSet.getString(rowIndex, 'name'),
    providerType: parseProviderType(resultSet.getString(rowIndex, 'provider_type')),
    primaryUrl: resultSet.getString(rowIndex, 'primary_url'),
    lanUrl: lanUrlRaw === '' ? undefined : lanUrlRaw,
    alternativeUrls: parseStringArray(resultSet.getString(rowIndex, 'alternative_urls_json')),
    username: usernameRaw === '' ? undefined : usernameRaw,
    credentialRef: resultSet.getString(rowIndex, 'credential_ref'),
    enabled: resultSet.getNumber(rowIndex, 'enabled') === 1,
    createdAtMs: resultSet.getNumber(rowIndex, 'created_at_ms'),
    updatedAtMs: resultSet.getNumber(rowIndex, 'updated_at_ms')
  };
}
