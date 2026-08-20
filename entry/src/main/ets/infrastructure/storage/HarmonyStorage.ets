import { common } from '@kit.AbilityKit';
import { asset } from '@kit.AssetStoreKit';
import { preferences, relationalStore } from '@kit.ArkData';
import { util } from '@kit.ArkTS';
import { DomainError } from '../../domain/error/DomainError';
import { PreferencesStore, RdbResultSet, RdbStore, RdbValue, SecureStorage } from './StorageContracts';

// ---- Real PreferencesStore (ohos.data.preferences) ----
export class HarmonyPreferencesStore implements PreferencesStore {
  private readonly context: common.Context;
  private readonly name: string;
  private prefs: preferences.Preferences | undefined = undefined;

  constructor(context: common.Context, name: string) {
    this.context = context;
    this.name = name;
  }

  private async ensure(): Promise<preferences.Preferences> {
    if (this.prefs === undefined) {
      this.prefs = await preferences.getPreferences(this.context, this.name);
    }
    return this.prefs;
  }

  async getString(key: string, defaultValue: string): Promise<string> {
    const p: preferences.Preferences = await this.ensure();
    const v = await p.get(key, defaultValue);
    return typeof v === 'string' ? v : defaultValue;
  }

  async putString(key: string, value: string): Promise<void> {
    const p: preferences.Preferences = await this.ensure();
    await p.put(key, value);
    await p.flush();
  }

  async getNumber(key: string, defaultValue: number): Promise<number> {
    const p: preferences.Preferences = await this.ensure();
    const v = await p.get(key, defaultValue);
    return typeof v === 'number' ? v : defaultValue;
  }

  async putNumber(key: string, value: number): Promise<void> {
    const p: preferences.Preferences = await this.ensure();
    await p.put(key, value);
    await p.flush();
  }

  async getBoolean(key: string, defaultValue: boolean): Promise<boolean> {
    const p: preferences.Preferences = await this.ensure();
    const v = await p.get(key, defaultValue);
    return typeof v === 'boolean' ? v : defaultValue;
  }

  async putBoolean(key: string, value: boolean): Promise<void> {
    const p: preferences.Preferences = await this.ensure();
    await p.put(key, value);
    await p.flush();
  }

  async remove(key: string): Promise<void> {
    const p: preferences.Preferences = await this.ensure();
    await p.delete(key);
    await p.flush();
  }
}

// ---- Real SecureStorage (ohos.security.asset, Asset Store Kit) ----
// Credentials (password/token) live ONLY here; never in Preferences/RDB/logs.
export class AssetSecureStorage implements SecureStorage {
  private readonly encoder: util.TextEncoder = new util.TextEncoder();
  private readonly decoder: util.TextDecoder = new util.TextDecoder();

  async putSecret(key: string, secret: string): Promise<void> {
    const attrs: asset.AssetMap = new Map<asset.Tag, asset.Value>();
    attrs.set(asset.Tag.ALIAS, this.encoder.encode(key));
    attrs.set(asset.Tag.SECRET, this.encoder.encode(secret));
    attrs.set(asset.Tag.ACCESSIBILITY, asset.Accessibility.DEVICE_FIRST_UNLOCKED);
    await asset.add(attrs);
  }

  async getSecret(key: string): Promise<string> {
    const query: asset.AssetMap = new Map<asset.Tag, asset.Value>();
    query.set(asset.Tag.ALIAS, this.encoder.encode(key));
    query.set(asset.Tag.RETURN_TYPE, asset.ReturnType.ALL);
    const results: Array<asset.AssetMap> = await asset.query(query);
    if (results.length === 0) {
      throw new DomainError('AUTHENTICATION', 'Secret not found for alias', false);
    }
    const secretValue: asset.Value | undefined = results[0].get(asset.Tag.SECRET);
    if (secretValue instanceof Uint8Array) {
      return this.decoder.decode(secretValue);
    }
    throw new DomainError('AUTHENTICATION', 'Secret missing or not a byte array', false);
  }

  async deleteSecret(key: string): Promise<void> {
    const query: asset.AssetMap = new Map<asset.Tag, asset.Value>();
    query.set(asset.Tag.ALIAS, this.encoder.encode(key));
    await asset.remove(query);
  }

  async contains(key: string): Promise<boolean> {
    const query: asset.AssetMap = new Map<asset.Tag, asset.Value>();
    query.set(asset.Tag.ALIAS, this.encoder.encode(key));
    try {
      const results: Array<asset.AssetMap> = await asset.query(query);
      return results.length > 0;
    } catch (e) {
      return false;
    }
  }
}

// ---- Real RdbStore (ohos.data.relationalStore) ----
export class HarmonyRdbStore implements RdbStore {
  private readonly context: common.Context;
  private readonly name: string;
  private store: relationalStore.RdbStore | undefined = undefined;

  constructor(context: common.Context, name: string) {
    this.context = context;
    this.name = name;
  }

  private async ensure(): Promise<relationalStore.RdbStore> {
    if (this.store === undefined) {
      const config: relationalStore.StoreConfig = {
        name: this.name,
        securityLevel: relationalStore.SecurityLevel.S2
      };
      this.store = await relationalStore.getRdbStore(this.context, config);
    }
    return this.store;
  }

  async execute(sql: string, bindArgs?: RdbValue[]): Promise<void> {
    const store: relationalStore.RdbStore = await this.ensure();
    await store.executeSql(sql, bindArgs === undefined ? [] : bindArgs);
  }

  async query(sql: string, bindArgs?: RdbValue[]): Promise<RdbResultSet> {
    const store: relationalStore.RdbStore = await this.ensure();
    const resultSet: relationalStore.ResultSet = await store.querySql(sql, bindArgs === undefined ? [] : bindArgs);
    return new HarmonyRdbResultSet(resultSet);
  }

  async getSchemaVersion(): Promise<number> {
    const store: relationalStore.RdbStore = await this.ensure();
    return store.version;
  }

  async setSchemaVersion(version: number): Promise<void> {
    const store: relationalStore.RdbStore = await this.ensure();
    store.version = version;
  }
}

class HarmonyRdbResultSet implements RdbResultSet {
  readonly rowCount: number;
  private readonly rows: Array<Map<string, string>> = [];

  constructor(resultSet: relationalStore.ResultSet) {
    this.rowCount = resultSet.rowCount;
    const columnNames: Array<string> = resultSet.getColumnNames();
    while (resultSet.goToNextRow()) {
      const row: Map<string, string> = new Map<string, string>();
      for (let i = 0; i < columnNames.length; i++) {
        const columnName: string = columnNames[i];
        const columnType: relationalStore.ColumnType = resultSet.getColumnTypeSync(i);
        let value: string = '';
        if (columnType === relationalStore.ColumnType.INTEGER) {
          value = resultSet.getLong(i).toString();
        } else if (columnType === relationalStore.ColumnType.REAL) {
          value = resultSet.getDouble(i).toString();
        } else if (columnType === relationalStore.ColumnType.NULL) {
          value = '';
        } else {
          value = resultSet.getString(i);
        }
        row.set(columnName, value);
      }
      this.rows.push(row);
    }
    resultSet.close();
  }

  getString(rowIndex: number, column: string): string {
    const row: Map<string, string> | undefined = this.rows[rowIndex];
    if (row === undefined) {
      return '';
    }
    const value: string | undefined = row.get(column);
    return value === undefined ? '' : value;
  }

  getNumber(rowIndex: number, column: string): number {
    const s: string = this.getString(rowIndex, column);
    if (s === '') {
      return 0;
    }
    return Number(s);
  }
}
