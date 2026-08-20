import { describe, expect, it } from '@ohos/hypium';
import { makeMediaKey, mediaKeyEquals, mediaKeyStableId } from '../main/ets/domain/model/MediaKey';

export default function domainModelTest() {
  describe('MediaKey', () => {
    it('stableId_contains_all_identity_fields', 0, () => {
      const id: string = mediaKeyStableId(makeMediaKey('p1', 's1', 'SONG', 'r1'));
      expect(id).assertEqual('p1|s1|SONG|r1');
    });

    it('equals_distinguishes_different_servers', 0, () => {
      const a = makeMediaKey('p1', 's1', 'SONG', 'r1');
      const b = makeMediaKey('p1', 's2', 'SONG', 'r1');
      expect(mediaKeyEquals(a, b)).assertFalse();
    });

    it('equals_never_collapses_to_remoteId', 0, () => {
      const a = makeMediaKey('p1', 's1', 'SONG', 'r1');
      const b = makeMediaKey('p2', 's1', 'SONG', 'r1');
      expect(mediaKeyEquals(a, b)).assertFalse();
    });
  });
}
