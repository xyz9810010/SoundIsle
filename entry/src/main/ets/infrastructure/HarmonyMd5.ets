import { cryptoFramework } from '@kit.CryptoArchitectureKit';
import { util } from '@kit.ArkTS';
import { hexEncode } from './Hex';

// Real MD5 digest using HarmonyOS Crypto Architecture Kit. Returns lowercase hex.
export class HarmonyMd5 {
  private static readonly encoder: util.TextEncoder = new util.TextEncoder();

  static md5Hex(input: string): string {
    const md: cryptoFramework.Md = cryptoFramework.createMd('MD5');
    md.updateSync({ data: HarmonyMd5.encoder.encode(input) });
    const digest: cryptoFramework.DataBlob = md.digestSync();
    const bytes: Uint8Array = digest.data;
    const arr: number[] = [];
    for (let i = 0; i < bytes.length; i++) {
      arr.push(bytes[i]);
    }
    return hexEncode(arr);
  }
}
