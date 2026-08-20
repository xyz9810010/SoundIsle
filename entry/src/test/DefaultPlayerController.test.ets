import { describe, expect, it } from '@ohos/hypium';
import { DefaultPlayerController } from '../main/ets/playback/DefaultPlayerController';
import { InMemoryPlayerStateStore, InMemoryQueueManager } from '../main/ets/playback/InMemoryPlayback';
import { EngineListener, PlaybackEngine, PlaybackResolver } from '../main/ets/playback/PlaybackContracts';
import { EnginePhase } from '../main/ets/playback/PlaybackState';
import { MediaKey, makeMediaKey } from '../main/ets/domain/model/MediaKey';
import { AudioSource, QueueItem, QueueSeed } from '../main/ets/domain/model/QueueModels';

function song(keyId: string): QueueItem {
  return { key: makeMediaKey('p', 's', 'SONG', keyId), titleSnapshot: 'T' + keyId, artistSnapshot: 'A' };
}

function seed(): QueueSeed {
  return { items: [song('1'), song('2')], currentIndex: 0, origin: { kind: 'ALBUM' } };
}

class FakeEngine implements PlaybackEngine {
  started: number = 0;
  prepared: number = 0;
  async prepare(source: AudioSource): Promise<void> { this.prepared += 1; }
  async start(): Promise<void> { this.started += 1; }
  async pause(): Promise<void> {}
  async seek(positionMs: number): Promise<void> {}
  async stop(): Promise<void> {}
  async release(): Promise<void> {}
  setListener(listener: EngineListener): void {}
}

class FakeResolver implements PlaybackResolver {
  private keys: MediaKey[] = [];
  private resolvers: Array<(s: AudioSource) => void> = [];
  async resolve(key: MediaKey): Promise<AudioSource> {
    this.keys.push(key);
    return new Promise<AudioSource>((resolve: (s: AudioSource) => void): void => {
      this.resolvers.push(resolve);
    });
  }
  complete(index: number): void {
    if (index < this.resolvers.length) {
      const key: MediaKey = this.keys[index];
      this.resolvers[index]({ mediaKey: key, uri: 'u' + index, routeId: 'r', sourceType: 'REMOTE_ORIGINAL' });
    }
  }
}

function flush(): Promise<void> {
  return new Promise<void>((resolve: () => void): void => {
    setTimeout(resolve, 0);
  });
}

export default function defaultPlayerControllerTest() {
  describe('DefaultPlayerController', () => {
    it('plays_first_item', 0, async () => {
      const qm: InMemoryQueueManager = new InMemoryQueueManager();
      const ss: InMemoryPlayerStateStore = new InMemoryPlayerStateStore();
      const resolver: FakeResolver = new FakeResolver();
      const engine: FakeEngine = new FakeEngine();
      const controller: DefaultPlayerController = new DefaultPlayerController(qm, ss, resolver, engine);

      controller.play(seed());
      resolver.complete(0);
      await flush();
      expect(engine.prepared).assertEqual(1);
      expect(engine.started).assertEqual(1);
      expect(ss.getSnapshot().intent).assertEqual('PLAY');
    });

    it('stale_resolution_does_not_start_engine', 0, async () => {
      const qm: InMemoryQueueManager = new InMemoryQueueManager();
      const ss: InMemoryPlayerStateStore = new InMemoryPlayerStateStore();
      const resolver: FakeResolver = new FakeResolver();
      const engine: FakeEngine = new FakeEngine();
      const controller: DefaultPlayerController = new DefaultPlayerController(qm, ss, resolver, engine);

      controller.play(seed());  // gen 1: resolve song '1'
      controller.next();        // gen 2: resolve song '2'
      resolver.complete(0);     // stale resolve for song '1'
      await flush();
      expect(engine.started).assertEqual(0);  // stale result dropped
      resolver.complete(1);     // current resolve for song '2'
      await flush();
      expect(engine.started).assertEqual(1);
      expect(ss.getSnapshot().currentMediaKey !== undefined).assertTrue();
    });

    it('pause_during_resolve_prevents_autostart', 0, async () => {
      const qm: InMemoryQueueManager = new InMemoryQueueManager();
      const ss: InMemoryPlayerStateStore = new InMemoryPlayerStateStore();
      const resolver: FakeResolver = new FakeResolver();
      const engine: FakeEngine = new FakeEngine();
      const controller: DefaultPlayerController = new DefaultPlayerController(qm, ss, resolver, engine);

      controller.play(seed());
      controller.pause();       // intent PAUSE during resolve
      resolver.complete(0);
      await flush();
      expect(engine.prepared).assertEqual(1);  // prepared, but must not auto-start
      expect(engine.started).assertEqual(0);
      expect(ss.getSnapshot().intent).assertEqual('PAUSE');
    });
  });
}
