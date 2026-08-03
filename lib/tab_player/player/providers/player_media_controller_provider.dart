import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockingbird/tab_player/player/providers/player_media_controller.dart';

//here must not use autoDispose, player is keepalive,
//because background audio service need to access it
final playerMediaControllerProvider = NotifierProvider(
  PlayerMediaControllerNotifier.new,
);

class PlayerMediaControllerNotifier extends Notifier<PlayerMediaControllerITF> {
  @override
  PlayerMediaControllerITF build() {
    // final videoController = VideoPlayerController.file(File(path));
    final mediaController = PlayerMediaController();
    ref.onDispose(() {
      assert(false, 'PlayerMediaControllerNotifier should never dispose');
      mediaController.dispose();
    });
    //its neccessary to await initialize, otherwise aspectratio etc will wrong
    // await videoController.initialize();
    //TODO deleted media pause
    return mediaController;
  }
}
