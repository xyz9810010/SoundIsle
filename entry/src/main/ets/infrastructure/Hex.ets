// Lowercase hex encoding of raw bytes (shared by MD5 and auth-token code).
export function hexEncode(bytes: number[]): string {
  const hex: string = '0123456789abcdef';
  let result: string = '';
  for (let i = 0; i < bytes.length; i++) {
    const b: number = bytes[i] & 0xff;
    result += hex.charAt((b >> 4) & 0xf) + hex.charAt(b & 0xf);
  }
  return result;
}
