import { DomainError } from '../domain/error/DomainError';

// Pure mapping from HTTP status / network failures to the stable domain error
// vocabulary (ERROR_MODEL.md). Kept free of @kit imports so it can be unit-tested.

export function isHttpSuccess(statusCode: number): boolean {
  return statusCode >= 200 && statusCode < 300;
}

export function mapHttpStatusToError(statusCode: number): DomainError {
  if (statusCode === 401) {
    return new DomainError('AUTHENTICATION', 'Server rejected credentials (HTTP 401)', false);
  }
  if (statusCode === 403) {
    return new DomainError('PERMISSION_DENIED', 'Server denied access (HTTP 403)', false);
  }
  if (statusCode >= 500) {
    return new DomainError('SERVER_UNAVAILABLE', 'Server error (HTTP ' + statusCode + ')', true);
  }
  return new DomainError('INVALID_RESPONSE', 'Unexpected HTTP status ' + statusCode, false);
}

export function mapNetworkExceptionToError(message: string): DomainError {
  const m: string = message.toLowerCase();
  if (m.includes('timeout') || m.includes('timed out')) {
    return new DomainError('TIMEOUT', 'Network request timed out', true, message);
  }
  if (m.includes('certificate') || m.includes('ssl') || m.includes('tls') || m.includes('handshake')) {
    return new DomainError('TLS', 'TLS/certificate error', false, message);
  }
  return new DomainError('NETWORK_UNAVAILABLE', 'Network request failed', true, message);
}
