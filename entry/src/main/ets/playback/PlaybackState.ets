import { MediaKey } from '../domain/model/MediaKey';

export type UserPlaybackIntent = 'PLAY' | 'PAUSE';

export type EnginePhase =
  'IDLE' | 'RESOLVING' | 'PREPARING' | 'READY' | 'PLAYING' | 'BUFFERING'
  | 'SEEKING' | 'COMPLETED' | 'RECOVERING' | 'ERROR' | 'RELEASED';

export type PlaybackInhibitor = 'SYSTEM_INTERRUPTION' | 'ROUTE_LOST' | 'FATAL_ERROR' | 'APP_POLICY';

export type PlayMode = 'SEQUENTIAL' | 'REPEAT_ALL' | 'REPEAT_ONE' | 'SHUFFLE';

// Orthogonal state dimensions (PLAYBACK_STATE_MACHINE.md), not one oversized enum.
export interface PlaybackSnapshot {
  readonly phase: EnginePhase;
  readonly intent: UserPlaybackIntent;
  readonly inhibitors: PlaybackInhibitor[];
  readonly currentMediaKey?: MediaKey;
  readonly positionMs: number;
  readonly generation: number;
  readonly pendingSeekMs?: number;
  readonly playMode: PlayMode;
}
