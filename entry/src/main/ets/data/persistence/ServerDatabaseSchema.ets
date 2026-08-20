import { DomainError } from '../../domain/error/DomainError';
import { RdbStore } from '../../infrastructure/storage/StorageContracts';

export const SERVER_SCHEMA_VERSION = 1;

// DATABASE_SCHEMA.md servers table. credential_ref is the ONLY credential-bearing column;
// no password/token/secret column exists.
export const CREATE_SERVERS_TABLE_SQL: string =
  'CREATE TABLE IF NOT EXISTS servers (' +
  'id TEXT PRIMARY KEY, ' +
  'name TEXT NOT NULL, ' +
  'provider_type TEXT NOT NULL, ' +
  'primary_url TEXT NOT NULL, ' +
  'lan_url TEXT, ' +
  'alternative_urls_json TEXT NOT NULL, ' +
  'username TEXT, ' +
  'credential_ref TEXT NOT NULL, ' +
  'enabled INTEGER NOT NULL, ' +
  'created_at_ms INTEGER NOT NULL, ' +
  'updated_at_ms INTEGER NOT NULL' +
  ')';

// One ordered statement-list per version (index = version). Version 0 = "no schema".
const SERVER_MIGRATIONS: string[][] = [
  [],
  [CREATE_SERVERS_TABLE_SQL]
];

// Idempotent, versioned migration. Never drops-and-recreates: each version's statements
// run exactly once, in order, then the schema version is bumped.
export async function ensureServerSchema(rdb: RdbStore): Promise<void> {
  const current: number = await rdb.getSchemaVersion();
  if (current === SERVER_SCHEMA_VERSION) {
    return;
  }
  if (current > SERVER_SCHEMA_VERSION) {
    throw new DomainError('DATABASE', 'Database schema version ' + current + ' is newer than supported ' + SERVER_SCHEMA_VERSION, false);
  }
  for (let v = current; v < SERVER_SCHEMA_VERSION; v++) {
    const statements: string[] | undefined = SERVER_MIGRATIONS[v + 1];
    if (statements === undefined) {
      throw new DomainError('DATABASE', 'Missing migration for schema version ' + (v + 1), false);
    }
    for (let i = 0; i < statements.length; i++) {
      await rdb.execute(statements[i]);
    }
    await rdb.setSchemaVersion(v + 1);
  }
}

// Map a raw RDB exception message to the stable DatabaseError category (ERROR_MODEL).
export function mapDatabaseError(message: string): DomainError {
  return new DomainError('DATABASE', 'Database operation failed', false, message);
}
