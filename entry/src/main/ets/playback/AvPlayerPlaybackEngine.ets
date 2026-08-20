import { media } from '@kit.MediaKit';
import { AudioSource } from '../domain/model/QueueModels';
import { DomainError } from '../domain/error/DomainError';
import { EngineListener, PlaybackEngine } from './PlaybackContracts';
import { EnginePhase } from './PlaybackState';
import { AvPlayerStateLike, mapAvPlayerState } from './EngineStateMapping';
import { AvPlayerLike, MediaAvPlayerAdapter } from './AvPlayerLike';
import { Logger } from '../infrastructure/Logger';

export class AvPlayerPlaybackEngine implements PlaybackEngine {
  private player: AvPlayerLike | undefined = undefined;
  private listener: EngineListener | undefined = undefined;
  private readonly createPlayer: () => Promise<AvPlayerLike>;
  private readonly logger: Logger | undefined;

  constructor(createPlayer?: () => Promise<AvPlayerLike>, logger?: Logger) {
    if (createPlayer === undefined) {
      this.createPlayer = async (): Promise<AvPlayerLike> => {
        return new MediaAvPlayerAdapter(await media.createAVPlayer());
      };
    } else {
      this.createPlayer = createPlayer;
    }
    this.logger = logger;
  }

  async prepare(source: AudioSource): Promise<void> {
    // Use a fresh AVPlayer per media source. Reusing one player and calling reset()
    // proved unreliable on-device (a track switch produced silence). A new player
    // starts in idle, which is the exact path the first play already follows.
    await this.discardPlayer();
    const player: AvPlayerLike = await this.createPlayer();
    this.registerEvents(player);
    this.player = player;
    this.setPhase('PREPARING');
    try {
      this.log('prepare remoteId=' + source.mediaKey.remoteId);
      player.url = source.uri;
      // Setting url triggers an ASYNC idle->initialized transition; prepare() is
      // only allowed once the player is initialized, so wait for that state first.
      await this.waitForState(player, 'initialized');
      await player.prepare();
      this.log('prepare done state=' + player.state);
    } catch (e) {
      this.setPhase('ERROR');
      const message: string = e instanceof Error ? e.message : String(e);
      this.log('prepare FAILED: ' + message);
      throw new DomainError('MEDIA_UNSUPPORTED', 'Playback prepare failed', false, message);
    }
  }

  async start(): Promise<void> {
    this.log('start: play()');
    await this.requirePlayer().play();
  }

  async pause(): Promise<void> {
    await this.requirePlayer().pause();
  }

  async seek(positionMs: number): Promise<void> {
    this.setPhase('SEEKING');
    this.requirePlayer().seek(positionMs);
  }

  async stop(): Promise<void> {
    await this.requirePlayer().stop();
  }

  async release(): Promise<void> {
    await this.discardPlayer();
    this.setPhase('RELEASED');
  }

  setListener(listener: EngineListener): void {
    this.listener = listener;
  }

  private async discardPlayer(): Promise<void> {
    if (this.player !== undefined) {
      const old: AvPlayerLike = this.player;
      this.player = undefined;
      try {
        await old.release();
      } catch (e) {
        this.log('release previous player failed: ' + (e instanceof Error ? e.message : String(e)));
      }
    }
  }

  private waitForState(player: AvPlayerLike, target: AvPlayerStateLike): Promise<void> {
    return new Promise<void>((resolve) => {
      let resolved: boolean = false;
      const finish = (): void => {
        if (!resolved) {
          resolved = true;
          resolve();
        }
      };
      if (player.state === target) {
        finish();
        return;
      }
      player.setStateListener((state): void => {
        if (state === target) {
          finish();
        }
      });
      // Re-check in case the transition happened between the check and registration.
      if (player.state === target) {
        finish();
      }
    });
  }

  private requirePlayer(): AvPlayerLike {
    if (this.player === undefined) {
      throw new DomainError('PLAYBACK_FATAL', 'Player is not prepared', false);
    }
    return this.player;
  }

  private registerEvents(player: AvPlayerLike): void {
    player.setStateListener((state): void => {
      this.log('state -> ' + state);
      this.setPhase(mapAvPlayerState(state));
    });
    player.setTimeListener((timeMs: number): void => {
      if (this.listener !== undefined) {
        this.listener.onPosition(timeMs);
      }
    });
    player.setSeekDoneListener((timeMs: number): void => {
      this.log('seekDone state=' + player.state);
      this.setPhase(mapAvPlayerState(player.state));
    });
    player.setErrorListener((message: string): void => {
      this.log('player error: ' + message);
      if (this.listener !== undefined) {
        this.listener.onError('PLAYBACK_FATAL', message);
      }
      this.setPhase('ERROR');
    });
  }

  private setPhase(phase: EnginePhase): void {
    if (this.listener !== undefined) {
      this.listener.onPhase(phase);
    }
  }

  private log(message: string): void {
    if (this.logger !== undefined) {
      this.logger.info('Playback', message);
    }
  }
}
