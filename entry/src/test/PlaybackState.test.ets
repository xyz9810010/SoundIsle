import { describe, expect, it } from '@ohos/hypium';
import { makeMediaKey } from '../main/ets/domain/model/MediaKey';
import { QueueItem, QueueSeed } from '../main/ets/domain/model/QueueModels';
import { InMemoryPlayerStateStore, InMemoryQueueManager } from '../main/ets/playback/InMemoryPlayback';

function song(keyId: string): QueueItem {
  return { key: makeMediaKey('p', 's', 'SONG', keyId), titleSnapshot: 'T' + keyId, artistSnapshot: 'A' };
}

export default function playbackStateTest() {
  describe('InMemoryPlayerStateStore', () => {
    it('starts_idle_paused', 0, () => {
      const store: InMemoryPlayerStateStore = new InMemoryPlayerStateStore();
      expect(store.getSnapshot().phase).assertEqual('IDLE');
      expect(store.getSnapshot().intent).assertEqual('PAUSE');
    });

    it('setIntent_updates_snapshot', 0, () => {
      const store: InMemoryPlayerStateStore = new InMemoryPlayerStateStore();
      store.setIntent('PLAY');
      expect(store.getSnapshot().intent).assertEqual('PLAY');
    });

    it('addInhibitor_is_idempotent', 0, () => {
      const store: InMemoryPlayerStateStore = new InMemoryPlayerStateStore();
      store.addInhibitor('FATAL_ERROR');
      store.addInhibitor('FATAL_ERROR');
      expect(store.getSnapshot().inhibitors.length).assertEqual(1);
    });
  });

  describe('InMemoryQueueManager', () => {
    it('loads_and_advances', 0, () => {
      const qm: InMemoryQueueManager = new InMemoryQueueManager();
      const seed: QueueSeed = { items: [song('1'), song('2')], currentIndex: 0, origin: { kind: 'ALBUM' } };
      qm.load(seed);
      expect(qm.size()).assertEqual(2);
      expect(qm.currentIndex()).assertEqual(0);
      qm.next();
      expect(qm.currentIndex()).assertEqual(1);
    });

    it('setCurrentIndex_is_bounds_checked', 0, () => {
      const qm: InMemoryQueueManager = new InMemoryQueueManager();
      qm.load({ items: [song('1')], currentIndex: 0, origin: { kind: 'SINGLE' } });
      expect(qm.setCurrentIndex(5)).assertFalse();
      expect(qm.setCurrentIndex(0)).assertTrue();
    });
  });
}
