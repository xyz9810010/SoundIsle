// Stable domain error vocabulary (ERROR_MODEL.md). Infrastructure/HTTP details never
// cross into domain/UI; they are mapped into one of these categories at the boundary.
export type DomainErrorCategory =
  'AUTHENTICATION'
  | 'NETWORK_UNAVAILABLE'
  | 'TIMEOUT'
  | 'TLS'
  | 'SERVER_UNAVAILABLE'
  | 'PERMISSION_DENIED'
  | 'UNSUPPORTED_CAPABILITY'
  | 'INVALID_RESPONSE'
  | 'MEDIA_UNSUPPORTED'
  | 'PLAYBACK_SOURCE_EXPIRED'
  | 'PLAYBACK_FATAL'
  | 'STORAGE_FULL'
  | 'LOCAL_FILE_CORRUPT'
  | 'DATABASE';

// Extends Error so ArkTS permits throwing it (arkts-limited-throw).
export class DomainError extends Error {
  readonly category: DomainErrorCategory;
  readonly retryable: boolean;
  readonly causeText: string | undefined;

  constructor(category: DomainErrorCategory, message: string, retryable: boolean, causeText?: string) {
    super(message);
    this.category = category;
    this.retryable = retryable;
    this.causeText = causeText;
  }

  static unsupported(message: string): DomainError {
    return new DomainError('UNSUPPORTED_CAPABILITY', message, false);
  }

  static invalidResponse(message: string): DomainError {
    return new DomainError('INVALID_RESPONSE', message, false);
  }
}
