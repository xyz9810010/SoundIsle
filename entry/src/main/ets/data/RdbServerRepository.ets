import { DomainError } from '../domain/error/DomainError';
import { ServerRepository } from '../domain/repository/ServerRepository';
import { ServerProfile } from '../domain/model/UserModels';
import { RdbResultSet, RdbStore } from '../infrastructure/storage/StorageContracts';
import { ensureServerSchema, mapDatabaseError } from './persistence/ServerDatabaseSchema';
import { profileToRow, rowToProfile } from './ServerProfileMapper';

const SELECT_ALL_SQL: string = 'SELECT * FROM servers ORDER BY created_at_ms';
const SELECT_BY_ID_SQL: string = 'SELECT * FROM servers WHERE id = ?';
const SELECT_ID_SQL: string = 'SELECT id FROM servers WHERE id = ?';
const INSERT_SQL: string =
  'INSERT INTO servers (id, name, provider_type, primary_url, lan_url, alternative_urls_json, username, credential_ref, enabled, created_at_ms, updated_at_ms) ' +
  'VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)';
const UPDATE_SQL: string =
  'UPDATE servers SET name = ?, provider_type = ?, primary_url = ?, lan_url = ?, alternative_urls_json = ?, username = ?, credential_ref = ?, enabled = ?, updated_at_ms = ? WHERE id = ?';
const DELETE_SQL: string = 'DELETE FROM servers WHERE id = ?';

function messageOf(e: Object): string {
  return e instanceof Error ? e.message : String(e);
}

// Durable ServerProfile repository backed by the RdbStore abstraction (NOT coupled to
// any HarmonyOS RDB API). Only credential_ref is persisted; secrets never pass through here.
export class RdbServerRepository implements ServerRepository {
  private readonly rdb: RdbStore;

  constructor(rdb: RdbStore) {
    this.rdb = rdb;
  }

  private async ready(): Promise<void> {
    await ensureServerSchema(this.rdb);
  }

  async list(): Promise<ServerProfile[]> {
    await this.ready();
    let resultSet: RdbResultSet;
    try {
      resultSet = await this.rdb.query(SELECT_ALL_SQL);
    } catch (e) {
      throw mapDatabaseError(messageOf(e));
    }
    const result: ServerProfile[] = [];
    for (let i = 0; i < resultSet.rowCount; i++) {
      result.push(rowToProfile(resultSet, i));
    }
    return result;
  }

  async get(id: string): Promise<ServerProfile> {
    await this.ready();
    let resultSet: RdbResultSet;
    try {
      resultSet = await this.rdb.query(SELECT_BY_ID_SQL, [id]);
    } catch (e) {
      throw mapDatabaseError(messageOf(e));
    }
    if (resultSet.rowCount === 0) {
      throw new Error('Server profile not found: ' + id);
    }
    return rowToProfile(resultSet, 0);
  }

  async create(profile: ServerProfile): Promise<void> {
    await this.ready();
    let existing: RdbResultSet;
    try {
      existing = await this.rdb.query(SELECT_ID_SQL, [profile.id]);
    } catch (e) {
      throw mapDatabaseError(messageOf(e));
    }
    if (existing.rowCount > 0) {
      throw new Error('Server already exists: ' + profile.id);
    }
    const row = profileToRow(profile);
    try {
      await this.rdb.execute(INSERT_SQL, [
        row.id, row.name, row.providerType, row.primaryUrl, row.lanUrl, row.alternativeUrlsJson,
        row.username, row.credentialRef, row.enabled, row.createdAtMs, row.updatedAtMs
      ]);
    } catch (e) {
      throw mapDatabaseError(messageOf(e));
    }
  }

  async update(profile: ServerProfile): Promise<void> {
    await this.ready();
    let existing: RdbResultSet;
    try {
      existing = await this.rdb.query(SELECT_ID_SQL, [profile.id]);
    } catch (e) {
      throw mapDatabaseError(messageOf(e));
    }
    if (existing.rowCount === 0) {
      throw new Error('Server profile not found: ' + profile.id);
    }
    const row = profileToRow(profile);
    try {
      await this.rdb.execute(UPDATE_SQL, [
        row.name, row.providerType, row.primaryUrl, row.lanUrl, row.alternativeUrlsJson,
        row.username, row.credentialRef, row.enabled, row.updatedAtMs, row.id
      ]);
    } catch (e) {
      throw mapDatabaseError(messageOf(e));
    }
  }

  async remove(id: string): Promise<void> {
    await this.ready();
    try {
      await this.rdb.execute(DELETE_SQL, [id]);
    } catch (e) {
      throw mapDatabaseError(messageOf(e));
    }
  }
}
