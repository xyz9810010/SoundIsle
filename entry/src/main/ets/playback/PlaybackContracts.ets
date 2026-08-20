import { MediaKey } from '../domain/model/MediaKey';
import { AudioSource, QueueItem, QueueSeed } from '../domain/model/QueueModels';
import { DomainErrorCategory } from '../domain/error/DomainError';
import { EnginePhase, PlaybackInhibitor, PlaybackSnapshot, UserPlaybackIntent } from './PlaybackState';

export interface PlaybackListener {
  onSnapshot(snapshot: PlaybackSnapshot): void;
}

// The playback state authority (ARCHITECTURE.md). AVSession never writes state
// directly; it emits controller commands.
export interface PlayerStateStore {
  getSnapshot(): PlaybackSnapshot;
  setIntent(intent: UserPlaybackIntent): void;
  setPhase(phase: EnginePhase): void;
  addInhibitor(inhibitor: PlaybackInhibitor): void;
  removeInhibitor(inhibitor: PlaybackInhibitor): void;
  setCurrentMediaKey(key: MediaKey): void;
  setPositionMs(positionMs: number): void;
  subscribe(listener: PlaybackListener): void;
  unsubscribe(listener: PlaybackListener): void;
}

// The real-time local queue authority.
export interface QueueManager {
  load(seed: QueueSeed): void;
  current(): QueueItem | undefined;
  currentIndex(): number;
  size(): number;
  next(): QueueItem | undefined;
  previous(): QueueItem | undefined;
  setCurrentIndex(index: number): boolean;
  items(): QueueItem[];
}

// Application-scoped facade consumed by presentation.
export interface PlayerController {
  play(seed: QueueSeed): void;
  pause(): void;
  resume(): void;
  seek(positionMs: number): void;
  next(): void;
  previous(): void;
  snapshot(): PlaybackSnapshot;
}

export interface PlaybackResolver {
  resolve(key: MediaKey): Promise<AudioSource>;
}

export interface PlaybackRecovery {
  recover(last: PlaybackSnapshot): Promise<AudioSource>;
}

export interface EngineListener {
  onPhase(phase: EnginePhase): void;
  onPosition(positionMs: number): void;
  onError(category: DomainErrorCategory, message: string): void;
}

export interface PlaybackEngine {
  prepare(source: AudioSource): Promise<void>;
  start(): Promise<void>;
  pause(): Promise<void>;
  seek(positionMs: number): Promise<void>;
  stop(): Promise<void>;
  release(): Promise<void>;
  setListener(listener: EngineListener): void;
}

export interface AVSessionCommandListener {
  onPlay(): void;
  onPause(): void;
  onNext(): void;
  onPrevious(): void;
  onSeek(positionMs: number): void;
}

export interface AVSessionAdapter {
  activate(): void;
  deactivate(): void;
  publish(snapshot: PlaybackSnapshot): void;
  setCommandListener(listener: AVSessionCommandListener): void;
}
