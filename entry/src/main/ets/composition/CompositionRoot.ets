import { common } from '@kit.AbilityKit';
import { DownloadRepository } from '../domain/repository/DownloadRepository';
import { FavoriteRepository } from '../domain/repository/FavoriteRepository';
import { MusicRepository } from '../domain/repository/MusicRepository';
import { PlaylistRepository } from '../domain/repository/PlaylistRepository';
import { ServerRepository } from '../domain/repository/ServerRepository';
import { InMemoryDownloadRepository, InMemoryFavoriteRepository, InMemoryMusicRepository, InMemoryPlaylistRepository } from '../data/InMemoryRepositories';
import { RdbServerRepository } from '../data/RdbServerRepository';
import { ServerConnectionFlow } from '../domain/server/ServerConnectionFlow';
import { BrowseService } from '../domain/server/BrowseService';
import { HilogLogger, Logger } from '../infrastructure/Logger';
import { HarmonyNetworkClient, NetworkClient } from '../infrastructure/NetworkClient';
import { FileStorage, PreferencesStore, RdbStore, SecureStorage } from '../infrastructure/storage/StorageContracts';
import { AssetSecureStorage, HarmonyPreferencesStore, HarmonyRdbStore } from '../infrastructure/storage/HarmonyStorage';
import { InMemoryFileStorage } from '../infrastructure/storage/InMemoryStorage';
import { InMemoryPlayerStateStore, InMemoryQueueManager } from '../playback/InMemoryPlayback';
import { PlayerController, PlayerStateStore, PlaybackEngine, PlaybackResolver, QueueManager } from '../playback/PlaybackContracts';
import { ProviderPlaybackResolver } from '../playback/ProviderPlaybackResolver';
import { AvPlayerPlaybackEngine } from '../playback/AvPlayerPlaybackEngine';
import { DefaultPlayerController } from '../playback/DefaultPlayerController';
import { ProviderFactory } from '../providers/ProviderFactory';

// Long-lived, application-scoped dependencies. Pages never instantiate
// repositories/providers/player core; they resolve them from this container.
export class AppContainer {
  readonly logger: Logger;
  readonly networkClient: NetworkClient;
  readonly preferences: PreferencesStore;
  readonly secureStorage: SecureStorage;
  readonly fileStorage: FileStorage;
  readonly rdb: RdbStore;
  readonly musicRepository: MusicRepository;
  readonly favoriteRepository: FavoriteRepository;
  readonly playlistRepository: PlaylistRepository;
  readonly serverRepository: ServerRepository;
  readonly downloadRepository: DownloadRepository;
  readonly providerFactory: ProviderFactory;
  readonly serverConnectionFlow: ServerConnectionFlow;
  readonly browseService: BrowseService;
  readonly playbackResolver: PlaybackResolver;
  readonly playerStateStore: PlayerStateStore;
  readonly queueManager: QueueManager;
  readonly playerController: PlayerController;

  constructor(logger: Logger, networkClient: NetworkClient, preferences: PreferencesStore,
    secureStorage: SecureStorage, fileStorage: FileStorage, rdb: RdbStore,
    musicRepository: MusicRepository, favoriteRepository: FavoriteRepository,
    playlistRepository: PlaylistRepository, serverRepository: ServerRepository,
    downloadRepository: DownloadRepository, providerFactory: ProviderFactory,
    serverConnectionFlow: ServerConnectionFlow, browseService: BrowseService,
    playbackResolver: PlaybackResolver,
    playerStateStore: PlayerStateStore, queueManager: QueueManager,
    playerController: PlayerController) {
    this.logger = logger;
    this.networkClient = networkClient;
    this.preferences = preferences;
    this.secureStorage = secureStorage;
    this.fileStorage = fileStorage;
    this.rdb = rdb;
    this.musicRepository = musicRepository;
    this.favoriteRepository = favoriteRepository;
    this.playlistRepository = playlistRepository;
    this.serverRepository = serverRepository;
    this.downloadRepository = downloadRepository;
    this.providerFactory = providerFactory;
    this.serverConnectionFlow = serverConnectionFlow;
    this.browseService = browseService;
    this.playbackResolver = playbackResolver;
    this.playerStateStore = playerStateStore;
    this.queueManager = queueManager;
    this.playerController = playerController;
  }
}

// Exactly one application-level composition root (COMPOSITION_ROOT_SPEC.md).
export class CompositionRoot {
  private static container: AppContainer | undefined = undefined;

  static initialize(context: common.Context, logger?: Logger): AppContainer {
    if (CompositionRoot.container === undefined) {
      const actualLogger: Logger = logger === undefined ? new HilogLogger() : logger;
      CompositionRoot.container = CompositionRoot.build(context, actualLogger);
      actualLogger.info('Composition', 'Composition root initialized');
    }
    return CompositionRoot.container;
  }

  static get(): AppContainer {
    if (CompositionRoot.container === undefined) {
      throw new Error('CompositionRoot is not initialized');
    }
    return CompositionRoot.container;
  }

  private static build(context: common.Context, logger: Logger): AppContainer {
    const networkClient: NetworkClient = new HarmonyNetworkClient();
    const preferences: PreferencesStore = new HarmonyPreferencesStore(context, 'soundisle_settings');
    const secureStorage: SecureStorage = new AssetSecureStorage();
    const fileStorage: FileStorage = new InMemoryFileStorage();
    const rdb: RdbStore = new HarmonyRdbStore(context, 'soundisle.db');

    // ServerRepository is now RDB-backed (M1-02); other repositories stay in-memory until needed.
    const musicRepository: MusicRepository = new InMemoryMusicRepository();
    const favoriteRepository: FavoriteRepository = new InMemoryFavoriteRepository();
    const playlistRepository: PlaylistRepository = new InMemoryPlaylistRepository();
    const serverRepository: ServerRepository = new RdbServerRepository(rdb);
    const downloadRepository: DownloadRepository = new InMemoryDownloadRepository();

    const providerFactory: ProviderFactory = new ProviderFactory(networkClient);
    const serverConnectionFlow: ServerConnectionFlow = new ServerConnectionFlow(providerFactory, secureStorage, serverRepository);
    const browseService: BrowseService = new BrowseService(serverRepository, secureStorage, providerFactory);
    const playbackResolver: PlaybackResolver = new ProviderPlaybackResolver(serverRepository, secureStorage, providerFactory);
    const playerStateStore: PlayerStateStore = new InMemoryPlayerStateStore();
    const queueManager: QueueManager = new InMemoryQueueManager();
    const playbackEngine: PlaybackEngine = new AvPlayerPlaybackEngine(undefined, logger);
    const playerController: PlayerController = new DefaultPlayerController(queueManager, playerStateStore, playbackResolver, playbackEngine);

    return new AppContainer(logger, networkClient, preferences, secureStorage, fileStorage, rdb,
      musicRepository, favoriteRepository, playlistRepository, serverRepository, downloadRepository,
      providerFactory, serverConnectionFlow, browseService, playbackResolver, playerStateStore, queueManager, playerController);
  }
}
