import { MediaKey } from '../domain/model/MediaKey';
import { Album, Artist, Song } from '../domain/model/MediaModels';
import { AudioSource } from '../domain/model/QueueModels';
import { Page } from '../domain/Page';
import { ServerProfile } from '../domain/model/UserModels';
import { DomainError } from '../domain/error/DomainError';
import { ServerConnectionResult } from '../domain/server/ServerConnection';
import { HarmonyMd5 } from '../infrastructure/HarmonyMd5';
import { HttpRequest, NetworkClient } from '../infrastructure/NetworkClient';
import { joinUrl } from '../domain/url/ServerUrl';
import { emptyCapabilities, Provider, ProviderCapabilities } from '../domain/provider/Provider';
import { buildAuthQuery, generateSalt, OPENSUBSONIC_API_VERSION, OPENSUBSONIC_CLIENT_NAME } from './SubsonicAuth';
import { mapErrorCategoryToState, parsePingResponse } from './PingDtos';
import { parseAlbumList2Response, parseArtistsResponse, parseSearch3Response } from './OpenSubsonicMappers';
import { buildCapabilities, parseOpenSubsonicExtensions } from './OpenSubsonicCapabilities';

const AUTH_PROBE_TIMEOUT_MS: number = 15000;
const READ_TIMEOUT_MS: number = 15000;

export class OpenSubsonicProvider implements Provider {
  readonly profile: ServerProfile;
  readonly capabilities: ProviderCapabilities = emptyCapabilities();
  private readonly networkClient: NetworkClient;

  constructor(profile: ServerProfile, networkClient: NetworkClient) {
    this.profile = profile;
    this.networkClient = networkClient;
  }

  async ping(username: string, password: string): Promise<ServerConnectionResult> {
    try {
      const url: string = this.buildAuthedUrl('ping.view', username, password, '');
      const request: HttpRequest = this.getRequest(url, AUTH_PROBE_TIMEOUT_MS);
      const response = await this.networkClient.request(request);
      return parsePingResponse(response.body);
    } catch (e) {
      if (e instanceof DomainError) {
        return { state: mapErrorCategoryToState(e.category) };
      }
      return { state: 'INVALID_RESPONSE' };
    }
  }

  async listArtists(username: string, password: string, offset: number, size: number): Promise<Page<Artist>> {
    const url: string = this.buildAuthedUrl('getArtists.view', username, password,
      '&offset=' + offset + '&count=' + size);
    const response = await this.networkClient.request(this.getRequest(url, READ_TIMEOUT_MS));
    return parseArtistsResponse(response.body, this.profile.id, size);
  }

  async listAlbums(username: string, password: string, offset: number, size: number): Promise<Page<Album>> {
    const url: string = this.buildAuthedUrl('getAlbumList2.view', username, password,
      '&type=alphabeticalByName&offset=' + offset + '&size=' + size);
    const response = await this.networkClient.request(this.getRequest(url, READ_TIMEOUT_MS));
    return parseAlbumList2Response(response.body, this.profile.id, size);
  }

  async search(username: string, password: string, query: string, offset: number, size: number): Promise<Page<Song>> {
    const url: string = this.buildAuthedUrl('search3.view', username, password,
      '&query=' + encodeURIComponent(query) + '&songCount=' + size + '&songOffset=' + offset +
      '&artistCount=0&albumCount=0');
    const response = await this.networkClient.request(this.getRequest(url, READ_TIMEOUT_MS));
    return parseSearch3Response(response.body, this.profile.id, size);
  }

  async discoverCapabilities(username: string, password: string): Promise<ProviderCapabilities> {
    const url: string = this.buildAuthedUrl('getOpenSubsonicExtensions', username, password, '');
    const response = await this.networkClient.request(this.getRequest(url, READ_TIMEOUT_MS));
    const extensions: string[] = parseOpenSubsonicExtensions(response.body);
    return buildCapabilities(extensions);
  }

  async resolveAudioSource(username: string, password: string, key: MediaKey): Promise<AudioSource> {
    if (key.mediaType !== 'SONG') {
      throw DomainError.unsupported('Only SONG stream resolution is supported');
    }
    const url: string = this.buildAuthedUrl('stream', username, password,
      '&id=' + encodeURIComponent(key.remoteId) + '&format=raw');
    return {
      mediaKey: key,
      uri: url,
      routeId: this.profile.primaryUrl,
      sourceType: 'REMOTE_ORIGINAL'
    };
  }

  getCoverArtUrl(coverArtId: string): string {
    throw DomainError.unsupported('OpenSubsonic cover art URL construction is not implemented in the M1 baseline');
  }

  private buildAuthedUrl(endpoint: string, username: string, password: string, extraParams: string): string {
    const salt: string = generateSalt();
    const token: string = HarmonyMd5.md5Hex(password + salt);
    const query: string = buildAuthQuery(username, token, salt, OPENSUBSONIC_API_VERSION, OPENSUBSONIC_CLIENT_NAME, 'json') + extraParams;
    return joinUrl(this.profile.primaryUrl, 'rest', endpoint) + '?' + query;
  }

  private getRequest(url: string, timeoutMs: number): HttpRequest {
    return { url: url, method: 'GET', headers: new Map<string, string>(), timeoutMs: timeoutMs };
  }
}
