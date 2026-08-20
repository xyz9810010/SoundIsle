import { MediaKey } from '../domain/model/MediaKey';
import { AudioSource, QueueItem, QueueSeed } from '../domain/model/QueueModels';
import { DomainErrorCategory } from '../domain/error/DomainError';
import { EngineListener, PlaybackListener, PlayerController, PlaybackResolver, PlayerStateStore, PlaybackEngine, QueueManager } from './PlaybackContracts';
import { EnginePhase, PlaybackSnapshot } from './PlaybackState';

// Bridges engine events into the single PlayerStateStore (never a second state source).
class StateStoreListener implements EngineListener {
  private readonly stateStore: PlayerStateStore;

  constructor(stateStore: PlayerStateStore) {
    this.stateStore = stateStore;
  }

  onPhase(phase: EnginePhase): void {
    this.stateStore.setPhase(phase);
  }

  onPosition(positionMs: number): void {
    this.stateStore.setPositionMs(positionMs);
  }

  onError(category: DomainErrorCategory, message: string): void {
    this.stateStore.setPhase('ERROR');
  }
}

// Application-scoped PlayerController. Wires QueueManager + PlaybackResolver +
// PlaybackEngine + PlayerStateStore with a PlaybackGeneration for race safety:
// a new media selection increments the generation, and stale async resolve/prepare
// results are dropped (PLAYBACK_IMPLEMENTATION_CHECKLIST).
export class DefaultPlayerController implements PlayerController {
  private readonly queueManager: QueueManager;
  private readonly stateStore: PlayerStateStore;
  private readonly resolver: PlaybackResolver;
  private readonly engine: PlaybackEngine;
  private generation: number = 0;

  constructor(queueManager: QueueManager, stateStore: PlayerStateStore, resolver: PlaybackResolver, engine: PlaybackEngine) {
    this.queueManager = queueManager;
    this.stateStore = stateStore;
    this.resolver = resolver;
    this.engine = engine;
    this.engine.setListener(new StateStoreListener(this.stateStore));
  }

  play(seed: QueueSeed): void {
    this.queueManager.load(seed);
    const current: QueueItem | undefined = this.queueManager.current();
    if (current !== undefined) {
      this.playCurrent();
    }
  }

  pause(): void {
    this.stateStore.setIntent('PAUSE');
    this.engine.pause();
  }

  resume(): void {
    this.stateStore.setIntent('PLAY');
    this.engine.start();
  }

  seek(positionMs: number): void {
    this.stateStore.setPositionMs(positionMs);
    this.engine.seek(positionMs);
  }

  next(): void {
    const item: QueueItem | undefined = this.queueManager.next();
    if (item !== undefined) {
      this.playCurrent();
    }
  }

  previous(): void {
    const item: QueueItem | undefined = this.queueManager.previous();
    if (item !== undefined) {
      this.playCurrent();
    }
  }

  snapshot(): PlaybackSnapshot {
    return this.stateStore.getSnapshot();
  }

  private playCurrent(): void {
    const item: QueueItem | undefined = this.queueManager.current();
    if (item === undefined) {
      return;
    }
    this.generation += 1;
    const gen: number = this.generation;
    this.stateStore.setIntent('PLAY');
    this.stateStore.setCurrentMediaKey(item.key);
    this.stateStore.setPhase('RESOLVING');
    this.resolveAndPlay(item.key, gen);
  }

  private async resolveAndPlay(key: MediaKey, generation: number): Promise<void> {
    let source: AudioSource;
    try {
      source = await this.resolver.resolve(key);
    } catch (e) {
      if (generation === this.generation) {
        this.stateStore.setPhase('ERROR');
      }
      return;
    }
    if (generation !== this.generation) {
      return; // stale resolve result
    }
    this.stateStore.setPhase('PREPARING');
    try {
      await this.engine.prepare(source);
    } catch (e) {
      if (generation === this.generation) {
        this.stateStore.setPhase('ERROR');
      }
      return;
    }
    if (generation !== this.generation) {
      return; // stale prepare result
    }
    if (this.stateStore.getSnapshot().intent !== 'PLAY') {
      return; // user paused during resolve/prepare; do not auto-start
    }
    await this.engine.start();
  }
}
