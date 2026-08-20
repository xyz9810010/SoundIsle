import { CompositionRoot } from '../../composition/CompositionRoot';
import { Song } from '../../domain/model/MediaModels';
import { singleSongSeed } from '../../domain/model/QueueModels';

@Component
export struct SearchTab {
  @State query: string = '';
  @State songs: Song[] = [];
  @State message: string = '输入关键词搜索真实歌曲';
  @State busy: boolean = false;

  async search(): Promise<void> {
    if (this.busy || this.query.trim() === '') {
      return;
    }
    this.busy = true;
    this.message = '搜索中...';
    try {
      const page = await CompositionRoot.get().browseService.search(this.query.trim(), 0, 50);
      this.songs = page.items;
      this.message = '找到 ' + this.songs.length + ' 首歌曲';
    } catch (e) {
      this.message = '搜索失败: ' + (e instanceof Error ? e.message : '');
      this.songs = [];
    }
    this.busy = false;
  }

  build() {
    Column({ space: 12 }) {
      Row({ space: 8 }) {
        TextInput({ placeholder: '搜索歌曲', text: this.query })
          .layoutWeight(1)
          .onChange((value: string): void => {
            this.query = value;
          })
        Button('搜索')
          .enabled(!this.busy)
          .onClick((): void => {
            this.search();
          })
      }
      .width('100%')

      Text(this.message)
        .fontSize(13)
        .fontColor('#666666')

      List({ space: 8 }) {
        ForEach(this.songs, (s: Song) => {
          ListItem() {
            Column({ space: 2 }) {
              Text(s.title).fontSize(16)
              Text(s.artistNames.length > 0 ? s.artistNames[0] : '').fontSize(13).fontColor('#999999')
            }
            .alignItems(HorizontalAlign.Start)
          }
          .onClick((): void => {
            CompositionRoot.get().playerController.play(singleSongSeed(s, 'SEARCH'));
            this.message = '正在播放: ' + s.title;
          })
        }, (s: Song) => s.key.remoteId)
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
