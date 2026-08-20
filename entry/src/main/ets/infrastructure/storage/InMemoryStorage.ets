import { DomainError } from '../../domain/error/DomainError';
import { FileStorage, PreferencesStore, RdbResultSet, RdbStore, RdbValue, SecureStorage } from './StorageContracts';

// M0 in-memory skeletons. These implement the storage abstractions so the
// Composition Root can wire the graph; they are NOT production persistence and are
// replaced by @ohos.data.preferences / relationalStore / security.asset in M1.

export class InMemoryPreferencesStore implements PreferencesStore {
  private readonly strings: Map<string, string> = new Map<string, string>();
  private readonly numbers: Map<string, number> = new Map<string, number>();
  private readonly booleans: Map<string, boolean> = new Map<string, boolean>();

  async getString(key: string, defaultValue: string): Promise<string> {
    const v = this.strings.get(key);
    return v === undefined ? defaultValue : v;
  }

  async putString(key: string, value: string): Promise<void> {
    this.strings.set(key, value);
  }

  async getNumber(key: string, defaultValue: number): Promise<number> {
    const v = this.numbers.get(key);
    return v === undefined ? defaultValue : v;
  }

  async putNumber(key: string, value: number): Promise<void> {
    this.numbers.set(key, value);
  }

  async getBoolean(key: string, defaultValue: boolean): Promise<boolean> {
    const v = this.booleans.get(key);
    return v === undefined ? defaultValue : v;
  }

  async putBoolean(key: string, value: boolean): Promise<void> {
    this.booleans.set(key, value);
  }

  async remove(key: string): Promise<void> {
    this.strings.delete(key);
    this.numbers.delete(key);
    this.booleans.delete(key);
  }
}

export class InMemorySecureStorage implements SecureStorage {
  private readonly secrets: Map<string, string> = new Map<string, string>();

  async putSecret(key: string, secret: string): Promise<void> {
    this.secrets.set(key, secret);
  }

  async getSecret(key: string): Promise<string> {
    const v = this.secrets.get(key);
    if (v === undefined) {
      throw DomainError.unsupported('Secret not found for key: ' + key);
    }
    return v;
  }

  async deleteSecret(key: string): Promise<void> {
    this.secrets.delete(key);
  }

  async contains(key: string): Promise<boolean> {
    return this.secrets.has(key);
  }
}

export class InMemoryFileStorage implements FileStorage {
  private readonly files: Map<string, string> = new Map<string, string>();

  async writeText(path: string, content: string): Promise<void> {
    this.files.set(path, content);
  }

  async readText(path: string): Promise<string> {
    const v = this.files.get(path);
    return v === undefined ? '' : v;
  }

  async delete(path: string): Promise<void> {
    this.files.delete(path);
  }

  async exists(path: string): Promise<boolean> {
    return this.files.has(path);
  }
}

export class InMemoryRdbStore implements RdbStore {
  private schemaVersion: number = 0;

  async execute(sql: string, bindArgs?: RdbValue[]): Promise<void> {
    throw DomainError.unsupported('Relational database is not implemented in this in-memory double');
  }

  async query(sql: string, bindArgs?: RdbValue[]): Promise<RdbResultSet> {
    throw DomainError.unsupported('Relational database is not implemented in this in-memory double');
  }

  async getSchemaVersion(): Promise<number> {
    return this.schemaVersion;
  }

  async setSchemaVersion(version: number): Promise<void> {
    this.schemaVersion = version;
  }
}
