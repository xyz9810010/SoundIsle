import { describe, expect, it } from '@ohos/hypium';
import { InMemoryFavoriteRepository, InMemoryPlaylistRepository } from '../main/ets/data/InMemoryRepositories';
import { makeMediaKey } from '../main/ets/domain/model/MediaKey';

export default function repositoryTest() {
  describe('InMemoryFavoriteRepository', () => {
    it('adds_and_finds_favorite', 0, async () => {
      const repo: InMemoryFavoriteRepository = new InMemoryFavoriteRepository();
      const key = makeMediaKey('p1', 's1', 'SONG', 'r1');
      await repo.add(key);
      expect(await repo.isFavorite(key)).assertTrue();
    });

    it('does_not_collapse_identity_to_remoteId', 0, async () => {
      const repo: InMemoryFavoriteRepository = new InMemoryFavoriteRepository();
      const keyA = makeMediaKey('p1', 's1', 'SONG', 'r1');
      const keyB = makeMediaKey('p1', 's2', 'SONG', 'r1');
      await repo.add(keyA);
      expect(await repo.isFavorite(keyB)).assertFalse();
    });

    it('removes_favorite', 0, async () => {
      const repo: InMemoryFavoriteRepository = new InMemoryFavoriteRepository();
      const key = makeMediaKey('p1', 's1', 'SONG', 'r1');
      await repo.add(key);
      await repo.remove(key);
      expect(await repo.isFavorite(key)).assertFalse();
    });
  });

  describe('InMemoryPlaylistRepository', () => {
    it('creates_and_lists_playlist', 0, async () => {
      const repo: InMemoryPlaylistRepository = new InMemoryPlaylistRepository();
      const created = await repo.create('Road Trip');
      expect(created.name).assertEqual('Road Trip');
      const all = await repo.list();
      expect(all.length).assertEqual(1);
    });
  });
}
