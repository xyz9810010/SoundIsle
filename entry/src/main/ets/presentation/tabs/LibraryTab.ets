import { CompositionRoot } from '../../composition/CompositionRoot';
import { Album } from '../../domain/model/MediaModels';

@Component
export struct LibraryTab {
  @State albums: Album[] = [];
  @State message: string = '点击下方按钮加载真实专辑';
  @State busy: boolean = false;

  async load(): Promise<void> {
    if (this.busy) {
      return;
    }
    this.busy = true;
    this.message = '加载中...';
    try {
      const page = await CompositionRoot.get().browseService.listAlbums(0, 50);
      this.albums = page.items;
      this.message = '共加载 ' + this.albums.length + ' 张专辑' + (page.hasMore ? '（还有更多）' : '');
    } catch (e) {
      this.message = '加载失败: ' + (e instanceof Error ? e.message : '');
      this.albums = [];
    }
    this.busy = false;
  }

  build() {
    Column({ space: 12 }) {
      Button(this.busy ? '加载中...' : '加载专辑')
        .width('100%')
        .enabled(!this.busy)
        .onClick((): void => {
          this.load();
        })

      Text(this.message)
        .fontSize(13)
        .fontColor('#666666')

      List({ space: 8 }) {
        ForEach(this.albums, (a: Album) => {
          ListItem() {
            Column({ space: 2 }) {
              Text(a.name).fontSize(16)
              Text(a.artistNames.length > 0 ? a.artistNames[0] : '').fontSize(13).fontColor('#999999')
            }
            .alignItems(HorizontalAlign.Start)
          }
        }, (a: Album) => a.key.remoteId)
      }
      .layoutWeight(1)
      .width('100%')
    }
    .width('100%')
    .height('100%')
    .padding(16)
    .alignItems(HorizontalAlign.Start)
  }
}
