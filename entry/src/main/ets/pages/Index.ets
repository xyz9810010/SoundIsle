import { HomeTab } from '../presentation/tabs/HomeTab';
import { LibraryTab } from '../presentation/tabs/LibraryTab';
import { MyTab } from '../presentation/tabs/MyTab';
import { PlayerTab } from '../presentation/tabs/PlayerTab';
import { SearchTab } from '../presentation/tabs/SearchTab';

@Entry
@Component
struct Index {
  @Builder
  tabBar(title: string) {
    Column() {
      Text(title)
        .fontSize(14)
        .fontColor('#333333')
    }
  }

  build() {
    Tabs({ barPosition: BarPosition.End }) {
      TabContent() {
        HomeTab()
      }
      .tabBar(this.tabBar('Home'))

      TabContent() {
        LibraryTab()
      }
      .tabBar(this.tabBar('Library'))

      TabContent() {
        SearchTab()
      }
      .tabBar(this.tabBar('Search'))

      TabContent() {
        MyTab()
      }
      .tabBar(this.tabBar('My'))

      TabContent() {
        PlayerTab()
      }
      .tabBar(this.tabBar('Player'))
    }
    .width('100%')
    .height('100%')
    .barHeight(56)
    .backgroundColor('#F5F5F5')
  }
}
