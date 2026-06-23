import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../model/media.dart';
import 'player_state.dart';

abstract interface class PlayerInterfaceUIEvents {
  ItemScrollController get playerScrollController;
  Stream<PlayerState> playerPlayMedia(PlayerState state, Media media);
  Future<PlayerState> playerPlaySentence(PlayerState state, int index);
  Future<PlayerState> playerPositionChanged(PlayerState state, Duration position);
}
