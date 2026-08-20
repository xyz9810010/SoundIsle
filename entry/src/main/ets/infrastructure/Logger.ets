import { hilog } from '@kit.PerformanceAnalysisKit';

export type LogCategory =
  'Composition' | 'Network' | 'Storage' | 'Provider' | 'Playback' | 'Queue' | 'Repository' | 'Navigation' | 'Domain';

export type LogLevel = 'DEBUG' | 'INFO' | 'WARN' | 'ERROR';

export interface Logger {
  debug(category: LogCategory, message: string): void;
  info(category: LogCategory, message: string): void;
  warn(category: LogCategory, message: string): void;
  error(category: LogCategory, message: string): void;
}

export class HilogLogger implements Logger {
  private readonly domain: number = 0x0000;
  private readonly tag: string = 'SoundIsle';

  debug(category: LogCategory, message: string): void {
    hilog.debug(this.domain, this.tag, '[%{public}s] %{public}s', category, message);
  }

  info(category: LogCategory, message: string): void {
    hilog.info(this.domain, this.tag, '[%{public}s] %{public}s', category, message);
  }

  warn(category: LogCategory, message: string): void {
    hilog.warn(this.domain, this.tag, '[%{public}s] %{public}s', category, message);
  }

  error(category: LogCategory, message: string): void {
    hilog.error(this.domain, this.tag, '[%{public}s] %{public}s', category, message);
  }
}
