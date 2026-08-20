import { MediaKey } from '../model/MediaKey';
import { AudioSourceType, DownloadState } from '../model/StateTypes';

export interface DownloadRecord {
  readonly key: MediaKey;
  readonly state: DownloadState;
  readonly sourceType: AudioSourceType;
  readonly filePath?: string;
  readonly expectedSizeBytes?: number;
  readonly actualSizeBytes?: number;
  readonly createdAtMs: number;
  readonly completedAtMs?: number;
}

export interface DownloadRepository {
  list(): Promise<DownloadRecord[]>;
  enqueue(key: MediaKey, sourceType: AudioSourceType): Promise<void>;
  remove(key: MediaKey): Promise<void>;
  getState(key: MediaKey): Promise<DownloadState>;
}
