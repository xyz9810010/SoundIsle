// Storage abstractions (ARCHITECTURE.md Infrastructure layer).

export type RdbValue = string | number;

export interface PreferencesStore {
  getString(key: string, defaultValue: string): Promise<string>;
  putString(key: string, value: string): Promise<void>;
  getNumber(key: string, defaultValue: number): Promise<number>;
  putNumber(key: string, value: number): Promise<void>;
  getBoolean(key: string, defaultValue: boolean): Promise<boolean>;
  putBoolean(key: string, value: boolean): Promise<void>;
  remove(key: string): Promise<void>;
}

// Sole boundary for credentials/tokens (passwords, API keys, sensitive headers).
// There is no plaintext fallback: caller code never writes credentials elsewhere.
export interface SecureStorage {
  putSecret(key: string, secret: string): Promise<void>;
  getSecret(key: string): Promise<string>;
  deleteSecret(key: string): Promise<void>;
  contains(key: string): Promise<boolean>;
}

export interface FileStorage {
  writeText(path: string, content: string): Promise<void>;
  readText(path: string): Promise<string>;
  delete(path: string): Promise<void>;
  exists(path: string): Promise<boolean>;
}

export interface RdbResultSet {
  readonly rowCount: number;
  getString(rowIndex: number, column: string): string;
  getNumber(rowIndex: number, column: string): number;
}

// Relational store abstraction. bindArgs are the parameterized values; schema version
// is tracked via the underlying store's own version (PRAGMA user_version).
export interface RdbStore {
  execute(sql: string, bindArgs?: RdbValue[]): Promise<void>;
  query(sql: string, bindArgs?: RdbValue[]): Promise<RdbResultSet>;
  getSchemaVersion(): Promise<number>;
  setSchemaVersion(version: number): Promise<void>;
}
