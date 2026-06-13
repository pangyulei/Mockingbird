import 'dart:io';

import 'package:mockingbird/models/track.dart';
import 'package:video_player/video_player.dart';
import 'player_interface_ui_events.dart';
import 'player_state.dart';

class PlayerLogic implements PlayerInterfaceUIEvents {
  const PlayerLogic();

  @override
  Stream<PlayerState> playerPlayTrack(PlayerState state, Track track) async* {
    yield state.copyWith(track:track, showLoading: true);
    await state.playerController?.dispose();
    final playerController = VideoPlayerController.file(File(track.pathStr));
    await playerController.initialize();
    yield state.copyWith(track: track, playerController: playerController, showLoading: false);
  }
}
