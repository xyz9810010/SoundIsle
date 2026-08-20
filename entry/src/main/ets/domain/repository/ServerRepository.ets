import { ServerProfile } from '../model/UserModels';

// Durable server-profile CRUD. create/update are distinct: create fails on duplicate id,
// update fails on missing id. No credentials here — only credential_ref is persisted.
export interface ServerRepository {
  list(): Promise<ServerProfile[]>;
  get(id: string): Promise<ServerProfile>;
  create(profile: ServerProfile): Promise<void>;
  update(profile: ServerProfile): Promise<void>;
  remove(id: string): Promise<void>;
}
