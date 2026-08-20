import { EnginePhase } from './PlaybackState';

// String-union mirror of media.AVPlayerState (kept free of @kit so it is unit-testable).
export type AvPlayerStateLike = 'idle' | 'initialized' | 'prepared' | 'playing' | 'paused' | 'completed' | 'stopped' | 'released' | 'error';

export function mapAvPlayerState(state: AvPlayerStateLike): EnginePhase {
  if (state === 'idle') {
    return 'IDLE';
  }
  if (state === 'initialized') {
    return 'PREPARING';
  }
  if (state === 'prepared') {
    return 'READY';
  }
  if (state === 'playing') {
    return 'PLAYING';
  }
  if (state === 'paused') {
    return 'READY';
  }
  if (state === 'completed') {
    return 'COMPLETED';
  }
  if (state === 'stopped') {
    return 'IDLE';
  }
  if (state === 'released') {
    return 'RELEASED';
  }
  if (state === 'error') {
    return 'ERROR';
  }
  return 'IDLE';
}
