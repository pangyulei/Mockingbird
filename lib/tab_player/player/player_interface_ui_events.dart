import '../../models/track.dart';
import 'player_state.dart';

abstract interface class PlayerInterfaceUIEvents {
  Stream<PlayerState> playerPlayTrack(PlayerState state, Track track);
}
