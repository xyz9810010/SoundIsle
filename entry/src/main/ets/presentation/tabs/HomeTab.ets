@Component
export struct HomeTab {
  build() {
    Column() {
      Text('Home')
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
      Text('Home feed arrives in a later milestone')
        .fontSize(13)
        .fontColor('#999999')
        .margin({ top: 8 })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
  }
}
