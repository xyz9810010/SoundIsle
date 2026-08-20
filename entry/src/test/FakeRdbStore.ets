import { RdbResultSet, RdbStore, RdbValue } from '../main/ets/infrastructure/storage/StorageContracts';

export class FakeResultSet implements RdbResultSet {
  readonly rowCount: number;
  private readonly rows: Array<Map<string, string>> = [];

  constructor(rows: Array<Map<string, RdbValue>>) {
    this.rowCount = rows.length;
    for (let i = 0; i < rows.length; i++) {
      const src: Map<string, RdbValue> = rows[i];
      const row: Map<string, string> = new Map<string, string>();
      src.forEach((v: RdbValue, k: string): void => {
        row.set(k, String(v));
      });
      this.rows.push(row);
    }
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
    return s === '' ? 0 : Number(s);
  }
}

// Minimal SQL interpreter for exactly the statements the servers repository + schema
// emit. Not a general SQL engine; it exists only to exercise the repository end-to-end.
export class FakeRdbStore implements RdbStore {
  private version: number = 0;
  private rows: Array<Map<string, RdbValue>> = [];

  async execute(sql: string, bindArgs?: RdbValue[]): Promise<void> {
    const args: RdbValue[] = bindArgs === undefined ? [] : bindArgs;
    if (sql.startsWith('CREATE TABLE')) {
      return;
    }
    if (sql.startsWith('INSERT INTO servers')) {
      const columns: string[] = ['id', 'name', 'provider_type', 'primary_url', 'lan_url', 'alternative_urls_json', 'username', 'credential_ref', 'enabled', 'created_at_ms', 'updated_at_ms'];
      const row: Map<string, RdbValue> = new Map<string, RdbValue>();
      for (let i = 0; i < columns.length; i++) {
        if (i < args.length) {
          row.set(columns[i], args[i]);
        }
      }
      this.rows.push(row);
      return;
    }
    if (sql.startsWith('UPDATE servers SET')) {
      const id: string = args[args.length - 1] as string;
      const updateColumns: string[] = ['name', 'provider_type', 'primary_url', 'lan_url', 'alternative_urls_json', 'username', 'credential_ref', 'enabled', 'updated_at_ms'];
      for (let r = 0; r < this.rows.length; r++) {
        const row: Map<string, RdbValue> = this.rows[r];
        if (row.get('id') === id) {
          for (let i = 0; i < updateColumns.length; i++) {
            if (i < args.length) {
              row.set(updateColumns[i], args[i]);
            }
          }
        }
      }
      return;
    }
    if (sql.startsWith('DELETE FROM servers')) {
      const id: string = args[0] as string;
      const kept: Array<Map<string, RdbValue>> = [];
      for (let i = 0; i < this.rows.length; i++) {
        if (this.rows[i].get('id') !== id) {
          kept.push(this.rows[i]);
        }
      }
      this.rows = kept;
      return;
    }
  }

  async query(sql: string, bindArgs?: RdbValue[]): Promise<RdbResultSet> {
    const args: RdbValue[] = bindArgs === undefined ? [] : bindArgs;
    if (sql.startsWith('SELECT id FROM servers')) {
      const id: string = args[0] as string;
      const matched: Array<Map<string, RdbValue>> = [];
      for (let i = 0; i < this.rows.length; i++) {
        if (this.rows[i].get('id') === id) {
          const m: Map<string, RdbValue> = new Map<string, RdbValue>();
          m.set('id', id);
          matched.push(m);
        }
      }
      return new FakeResultSet(matched);
    }
    if (sql.startsWith('SELECT * FROM servers')) {
      if (sql.includes('WHERE id = ?')) {
        const id: string = args[0] as string;
        const matched: Array<Map<string, RdbValue>> = [];
        for (let i = 0; i < this.rows.length; i++) {
          if (this.rows[i].get('id') === id) {
            matched.push(this.rows[i]);
          }
        }
        return new FakeResultSet(matched);
      }
      const sorted: Array<Map<string, RdbValue>> = this.rows.slice();
      sorted.sort((a: Map<string, RdbValue>, b: Map<string, RdbValue>): number => {
        return Number(a.get('created_at_ms')) - Number(b.get('created_at_ms'));
      });
      return new FakeResultSet(sorted);
    }
    return new FakeResultSet([]);
  }

  async getSchemaVersion(): Promise<number> {
    return this.version;
  }

  async setSchemaVersion(version: number): Promise<void> {
    this.version = version;
  }
}
