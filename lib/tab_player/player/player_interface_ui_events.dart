import '../../model/media.dart';
import 'player_state.dart';

abstract interface class PlayerInterfaceUIEvents {
  Stream<PlayerState> playerPlayMedia(PlayerState state, Media media);
  PlayerState playerUpdatePosition(PlayerState state, Duration position);
}
