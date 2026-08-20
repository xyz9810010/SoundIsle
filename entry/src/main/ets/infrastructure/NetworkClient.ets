import { http } from '@kit.NetworkKit';
import { DomainError } from '../domain/error/DomainError';
import { isHttpSuccess, mapHttpStatusToError, mapNetworkExceptionToError } from './NetworkErrorMapping';

export interface HttpRequest {
  readonly url: string;
  readonly method: string;
  readonly headers: Map<string, string>;
  readonly body?: string;
  readonly timeoutMs: number;
}

export interface HttpResponse {
  readonly statusCode: number;
  readonly body: string;
}

export interface NetworkClient {
  request(request: HttpRequest): Promise<HttpResponse>;
}

// ArkTS forbids index signatures/props-by-index, so we map the two headers V1
// actually needs (Accept, Authorization) into a fixed declared interface. OpenSubsonic
// carries auth in query params (u/t/s) rather than headers, so this is sufficient.
interface HttpHeaderBag {
  'Accept': string;
  'Authorization'?: string;
}

function buildHeader(headers: Map<string, string>): HttpHeaderBag {
  const accept: string = headers.get('Accept') ?? 'application/json';
  const authorization: string | undefined = headers.get('Authorization');
  if (authorization !== undefined) {
    const bag: HttpHeaderBag = { 'Accept': accept, 'Authorization': authorization };
    return bag;
  }
  const bag: HttpHeaderBag = { 'Accept': accept };
  return bag;
}

function toRequestMethod(method: string): http.RequestMethod {
  const upper: string = method.toUpperCase();
  if (upper === 'POST') {
    return http.RequestMethod.POST;
  }
  if (upper === 'PUT') {
    return http.RequestMethod.PUT;
  }
  if (upper === 'DELETE') {
    return http.RequestMethod.DELETE;
  }
  return http.RequestMethod.GET;
}

// Real NetworkClient backed by @ohos.net.http. Maps transport/HTTP failures into
// the stable DomainError vocabulary; never lets raw HTTP exceptions cross upward.
export class HarmonyNetworkClient implements NetworkClient {
  private readonly client: http.HttpRequest = http.createHttp();

  async request(request: HttpRequest): Promise<HttpResponse> {
    const options: http.HttpRequestOptions = {
      method: toRequestMethod(request.method),
      header: buildHeader(request.headers),
      connectTimeout: request.timeoutMs,
      readTimeout: request.timeoutMs,
      expectDataType: http.HttpDataType.STRING
    };
    if (request.body !== undefined) {
      options.extraData = request.body;
    }
    try {
      const response: http.HttpResponse = await this.client.request(request.url, options);
      const statusCode: number = Number(response.responseCode);
      const body: string = typeof response.result === 'string' ? response.result : '';
      if (!isHttpSuccess(statusCode)) {
        throw mapHttpStatusToError(statusCode);
      }
      return { statusCode: statusCode, body: body };
    } catch (e) {
      if (e instanceof DomainError) {
        throw e;
      }
      const message: string = e instanceof Error ? e.message : String(e);
      throw mapNetworkExceptionToError(message);
    }
  }
}
