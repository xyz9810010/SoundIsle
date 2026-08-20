import { hexEncode } from '../infrastructure/Hex';

export const OPENSUBSONIC_API_VERSION: string = '1.16.1';
export const OPENSUBSONIC_CLIENT_NAME: string = 'SoundIsle';

export function generateSalt(length: number = 12): string {
  const chars: string = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  let result: string = '';
  for (let i = 0; i < length; i++) {
    result += chars.charAt(Math.floor(Math.random() * chars.length));
  }
  return result;
}

// token = hex(md5(password + salt)) per the Subsonic/OpenSubsonic salted-MD5 scheme.
export function computeTokenHex(password: string, salt: string, md5: (input: string) => number[]): string {
  return hexEncode(md5(password + salt));
}

export function buildAuthQuery(username: string, token: string, salt: string, version: string, client: string, format: string): string {
  return 'u=' + encodeURIComponent(username) +
    '&t=' + encodeURIComponent(token) +
    '&s=' + encodeURIComponent(salt) +
    '&v=' + encodeURIComponent(version) +
    '&c=' + encodeURIComponent(client) +
    '&f=' + encodeURIComponent(format);
}

// Redact the replayable parts (token, salt) of an auth URL for safe logging.
export function redactUrl(url: string): string {
  const qIndex: number = url.indexOf('?');
  if (qIndex < 0) {
    return url;
  }
  const base: string = url.substring(0, qIndex + 1);
  const query: string = url.substring(qIndex + 1);
  const parts: string[] = query.split('&');
  const redacted: string[] = [];
  for (let i = 0; i < parts.length; i++) {
    const part: string = parts[i];
    if (part.startsWith('t=') || part.startsWith('s=')) {
      redacted.push(part.substring(0, 2) + 'REDACTED');
    } else {
      redacted.push(part);
    }
  }
  return base + redacted.join('&');
}
