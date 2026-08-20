import { MediaKey } from '../domain/model/MediaKey';
import { QueueItem, QueueSeed } from '../domain/model/QueueModels';
import { PlayerController, PlayerStateStore, PlaybackListener, QueueManager } from './PlaybackContracts';
import { EnginePhase, PlaybackInhibitor, PlaybackSnapshot, PlayMode, UserPlaybackIntent } from './PlaybackState';

// M0 in-memory playback state skeletons. They own playback STATE only; no audio is
// produced (real PlaybackEngine lands in M2). The controller never flips to PLAYING
// solely from a user tap (PLAYBACK_STATE_MACHINE.md): it goes to RESOLVING.

export class InMemoryPlayerStateStore implements PlayerStateStore {
  private phase: EnginePhase = 'IDLE';
  private intent: UserPlaybackIntent = 'PAUSE';
  private inhibitors: PlaybackInhibitor[] = [];
  private currentMediaKey: MediaKey | undefined = undefined;
  private positionMs: number = 0;
  private generation: number = 0;
  private pendingSeekMs: number | undefined = undefined;
  private playMode: PlayMode = 'SEQUENTIAL';
  private listeners: PlaybackListener[] = [];

  getSnapshot(): PlaybackSnapshot {
    return {
      phase: this.phase,
      intent: this.intent,
      inhibitors: this.inhibitors.slice(),
      currentMediaKey: this.currentMediaKey,
      positionMs: this.positionMs,
      generation: this.generation,
      pendingSeekMs: this.pendingSeekMs,
      playMode: this.playMode
    };
  }

  setIntent(intent: UserPlaybackIntent): void {
    this.intent = intent;
    this.notify();
  }

  setPhase(phase: EnginePhase): void {
    this.phase = phase;
    this.notify();
  }

  addInhibitor(inhibitor: PlaybackInhibitor): void {
    if (this.inhibitors.indexOf(inhibitor) < 0) {
      this.inhibitors.push(inhibitor);
    }
    this.notify();
  }

  removeInhibitor(inhibitor: PlaybackInhibitor): void {
    const i: number = this.inhibitors.indexOf(inhibitor);
    if (i >= 0) {
      this.inhibitors.splice(i, 1);
    }
    this.notify();
  }

  setCurrentMediaKey(key: MediaKey): void {
    this.currentMediaKey = key;
    this.notify();
  }

  setPositionMs(positionMs: number): void {
    this.positionMs = positionMs;
    this.notify();
  }

  subscribe(listener: PlaybackListener): void {
    this.listeners.push(listener);
  }

  unsubscribe(listener: PlaybackListener): void {
    const i: number = this.listeners.indexOf(listener);
    if (i >= 0) {
      this.listeners.splice(i, 1);
    }
  }

  private notify(): void {
    const snapshot: PlaybackSnapshot = this.getSnapshot();
    this.listeners.forEach((l: PlaybackListener): void => {
      l.onSnapshot(snapshot);
    });
  }
}

export class InMemoryQueueManager implements QueueManager {
  private queue: QueueItem[] = [];
  private index: number = -1;

  load(seed: QueueSeed): void {
    this.queue = seed.items.slice();
    this.index = seed.currentIndex;
  }

  current(): QueueItem | undefined {
    if (this.index < 0 || this.index >= this.queue.length) {
      return undefined;
    }
    return this.queue[this.index];
  }

  currentIndex(): number {
    return this.index;
  }

  size(): number {
    return this.queue.length;
  }

  next(): QueueItem | undefined {
    if (this.queue.length === 0) {
      return undefined;
    }
    if (this.index + 1 < this.queue.length) {
      this.index += 1;
    }
    return this.queue[this.index];
  }

  previous(): QueueItem | undefined {
    if (this.queue.length === 0) {
      return undefined;
    }
    if (this.index > 0) {
      this.index -= 1;
    }
    return this.queue[this.index];
  }

  setCurrentIndex(index: number): boolean {
    if (index < 0 || index >= this.queue.length) {
      return false;
    }
    this.index = index;
    return true;
  }

  items(): QueueItem[] {
    return this.queue.slice();
  }
}

export class InMemoryPlayerController implements PlayerController {
  private readonly stateStore: PlayerStateStore;
  private readonly queueManager: QueueManager;

  constructor(stateStore: PlayerStateStore, queueManager: QueueManager) {
    this.stateStore = stateStore;
    this.queueManager = queueManager;
  }

  play(seed: QueueSeed): void {
    this.queueManager.load(seed);
    const current: QueueItem | undefined = this.queueManager.current();
    if (current !== undefined) {
      this.stateStore.setCurrentMediaKey(current.key);
    }
    this.stateStore.setIntent('PLAY');
    this.stateStore.setPhase('RESOLVING');
  }

  pause(): void {
    this.stateStore.setIntent('PAUSE');
  }

  resume(): void {
    this.stateStore.setIntent('PLAY');
  }

  seek(positionMs: number): void {
    this.stateStore.setPositionMs(positionMs);
  }

  next(): void {
    const item: QueueItem | undefined = this.queueManager.next();
    if (item !== undefined) {
      this.stateStore.setCurrentMediaKey(item.key);
    }
  }

  previous(): void {
    const item: QueueItem | undefined = this.queueManager.previous();
    if (item !== undefined) {
      this.stateStore.setCurrentMediaKey(item.key);
    }
  }

  snapshot(): PlaybackSnapshot {
    return this.stateStore.getSnapshot();
  }
}
