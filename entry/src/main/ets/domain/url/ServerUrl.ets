// URL normalization / construction per URL_CONSTRUCTION.md. Endpoints are never built
// by brittle string concatenation; a reverse-proxy base path is preserved, and no
// accidental "//" or lost subpath is produced.

export function normalizeBaseUrl(raw: string): string {
  let s: string = raw.trim();
  if (s.length === 0) {
    return '';
  }
  if (!(s.startsWith('http://') || s.startsWith('https://'))) {
    s = 'http://' + s;
  }
  // Strip trailing slashes while keeping the scheme ("://") intact.
  while (s.endsWith('/')) {
    const next: string = s.substring(0, s.length - 1);
    if (next.includes('://')) {
      s = next;
    } else {
      break;
    }
  }
  return s;
}

export function joinUrl(base: string, ...segments: string[]): string {
  let result: string = base;
  for (let i = 0; i < segments.length; i++) {
    const raw: string = segments[i].trim();
    if (raw.length === 0) {
      continue;
    }
    while (result.endsWith('/') && result.length > 8) {
      result = result.substring(0, result.length - 1);
    }
    let segment: string = raw;
    while (segment.startsWith('/')) {
      segment = segment.substring(1);
    }
    result = result + '/' + segment;
  }
  return result;
}
