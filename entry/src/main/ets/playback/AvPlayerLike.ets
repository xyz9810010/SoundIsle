import { media } from '@kit.MediaKit';
import { AvPlayerStateLike } from './EngineStateMapping';

export interface AvPlayerLike {
  url: string;
  readonly state: AvPlayerStateLike;
  prepare(): Promise<void>;
  play(): Promise<void>;
  pause(): Promise<void>;
  seek(timeMs: number): void;
  stop(): Promise<void>;
  reset(): Promise<void>;
  release(): Promise<void>;
  setStateListener(cb: (state: AvPlayerStateLike) => void): void;
  setTimeListener(cb: (timeMs: number) => void): void;
  setSeekDoneListener(cb: (timeMs: number) => void): void;
  setErrorListener(cb: (message: string) => void): void;
}

// Adapts the real media.AVPlayer to the minimal AvPlayerLike surface.
export class MediaAvPlayerAdapter implements AvPlayerLike {
  private readonly player: media.AVPlayer;

  constructor(player: media.AVPlayer) {
    this.player = player;
  }

  get url(): string {
    return this.player.url === undefined ? '' : this.player.url;
  }
  set url(value: string) {
    this.player.url = value;
  }
  get state(): AvPlayerStateLike {
    return this.player.state as AvPlayerStateLike;
  }

  prepare(): Promise<void> {
    return this.player.prepare();
  }
  play(): Promise<void> {
    return this.player.play();
  }
  pause(): Promise<void> {
    return this.player.pause();
  }
  seek(timeMs: number): void {
    this.player.seek(timeMs);
  }
  stop(): Promise<void> {
    return this.player.stop();
  }
  reset(): Promise<void> {
    return this.player.reset();
  }
  release(): Promise<void> {
    return this.player.release();
  }

  setStateListener(cb: (state: AvPlayerStateLike) => void): void {
    this.player.on('stateChange', (state: media.AVPlayerState, reason: media.StateChangeReason): void => {
      cb(state as AvPlayerStateLike);
    });
  }
  setTimeListener(cb: (timeMs: number) => void): void {
    this.player.on('timeUpdate', cb);
  }
  setSeekDoneListener(cb: (timeMs: number) => void): void {
    this.player.on('seekDone', cb);
  }
  setErrorListener(cb: (message: string) => void): void {
    this.player.on('error', (err: BusinessError): void => {
      cb(err.message);
    });
  }
}
