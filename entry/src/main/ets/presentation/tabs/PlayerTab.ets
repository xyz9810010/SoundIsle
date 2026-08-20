import { CompositionRoot } from '../../composition/CompositionRoot';
import { PlaybackSnapshot } from '../../playback/PlaybackState';

@Component
export struct PlayerTab {
  @State phase: string = 'IDLE';
  @State intent: string = 'PAUSE';

  aboutToAppear(): void {
    const snapshot: PlaybackSnapshot = CompositionRoot.get().playerController.snapshot();
    this.phase = snapshot.phase;
    this.intent = snapshot.intent;
  }

  build() {
    Column() {
      Text('Player')
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
      Text('Phase: ' + this.phase)
        .fontSize(14)
        .margin({ top: 12 })
      Text('Intent: ' + this.intent)
        .fontSize(14)
        .margin({ top: 4 })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
  }
}
