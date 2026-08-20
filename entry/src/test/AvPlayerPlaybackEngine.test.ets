import { describe, expect, it } from '@ohos/hypium';
import { AvPlayerPlaybackEngine } from '../main/ets/playback/AvPlayerPlaybackEngine';
import { AvPlayerLike } from '../main/ets/playback/AvPlayerLike';
import { AvPlayerStateLike } from '../main/ets/playback/EngineStateMapping';
import { AudioSource } from '../main/ets/domain/model/QueueModels';
import { makeMediaKey } from '../main/ets/domain/model/MediaKey';

class FakeAvPlayer implements AvPlayerLike {
  private urlVal: string = '';
  state: AvPlayerStateLike = 'idle';
  released: boolean = false;
  prepares: number = 0;
  plays: number = 0;
  preparedUrls: string[] = [];
  private stateListeners: Array<(s: AvPlayerStateLike) => void> = [];

  get url(): string {
    return this.urlVal;
  }
  set url(value: string) {
    this.urlVal = value;
    // model the real AVPlayer: setting url transitions idle -> initialized
    this.fireState('initialized');
  }

  async prepare(): Promise<void> {
    // model the real AVPlayer: prepare() is only legal from initialized
    if (this.state !== 'initialized') {
      throw new Error('prepare() requires initialized state, got ' + this.state);
    }
    this.prepares += 1;
    this.preparedUrls.push(this.urlVal);
    this.fireState('prepared');
  }
  async play(): Promise<void> {
    this.plays += 1;
    this.fireState('playing');
  }
  async pause(): Promise<void> {
    this.fireState('paused');
  }
  seek(timeMs: number): void {}
  async stop(): Promise<void> {
    this.fireState('stopped');
  }
  async reset(): Promise<void> {
    this.fireState('idle');
  }
  async release(): Promise<void> {
    this.released = true;
    this.fireState('released');
  }
  setStateListener(cb: (s: AvPlayerStateLike) => void): void {
    this.stateListeners.push(cb);
  }
  setTimeListener(cb: (timeMs: number) => void): void {}
  setSeekDoneListener(cb: (timeMs: number) => void): void {}
  setErrorListener(cb: (message: string) => void): void {}

  private fireState(s: AvPlayerStateLike): void {
    this.state = s;
    for (let i = 0; i < this.stateListeners.length; i++) {
      this.stateListeners[i](s);
    }
  }
}

function source(remoteId: string, uri: string): AudioSource {
  return { mediaKey: makeMediaKey('p', 's', 'SONG', remoteId), uri: uri, routeId: 'r', sourceType: 'REMOTE_ORIGINAL' };
}

export default function avPlayerPlaybackEngineTest() {
  describe('AvPlayerPlaybackEngine source replacement', () => {
    it('switching_track_replaces_loaded_url', 0, async () => {
      const players: FakeAvPlayer[] = [];
      const engine: AvPlayerPlaybackEngine = new AvPlayerPlaybackEngine(async (): Promise<AvPlayerLike> => {
        const fake: FakeAvPlayer = new FakeAvPlayer();
        players.push(fake);
        return fake;
      });

      await engine.prepare(source('A', 'http://srv/rest/stream?id=A'));
      await engine.start();
      expect(players.length).assertEqual(1);
      expect(players[0].url).assertEqual('http://srv/rest/stream?id=A');
      expect(players[0].preparedUrls[players[0].preparedUrls.length - 1]).assertEqual('http://srv/rest/stream?id=A');
      expect(players[0].released).assertEqual(false);

      // switch to B while A is playing -> old player released, fresh player loads B
      await engine.prepare(source('B', 'http://srv/rest/stream?id=B'));
      await engine.start();
      expect(players.length).assertEqual(2); // a NEW player was created
      expect(players[0].released).assertEqual(true); // old player released (A stopped)
      expect(players[1].url).assertEqual('http://srv/rest/stream?id=B'); // actual loaded source replaced
      expect(players[1].preparedUrls[players[1].preparedUrls.length - 1]).assertEqual('http://srv/rest/stream?id=B');
    });
  });
}
