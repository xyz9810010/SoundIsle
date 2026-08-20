import { describe, expect, it } from '@ohos/hypium';
import { mapAvPlayerState } from '../main/ets/playback/EngineStateMapping';

export default function engineStateMappingTest() {
  describe('mapAvPlayerState', () => {
    it('maps_avplayer_states_to_engine_phases', 0, () => {
      expect(mapAvPlayerState('idle')).assertEqual('IDLE');
      expect(mapAvPlayerState('initialized')).assertEqual('PREPARING');
      expect(mapAvPlayerState('prepared')).assertEqual('READY');
      expect(mapAvPlayerState('playing')).assertEqual('PLAYING');
      expect(mapAvPlayerState('paused')).assertEqual('READY');
      expect(mapAvPlayerState('completed')).assertEqual('COMPLETED');
      expect(mapAvPlayerState('stopped')).assertEqual('IDLE');
      expect(mapAvPlayerState('released')).assertEqual('RELEASED');
      expect(mapAvPlayerState('error')).assertEqual('ERROR');
    });
  });
}
