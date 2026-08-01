
import 'package:mockingbird/db/providers/db_playing_media_provider.dart';
import 'package:mockingbird/tab_player/player/providers/player_media_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'player_media_controller_provider.g.dart';

@riverpod
class PlayerVideoController extends _$PlayerVideoController {
  @override
  Future<PlayerMediaControllerITF?> build() async {
    // final String? path = (await ref.watch(dbPlayingMediaProvider.future))?.path;
    final String? path = await ref.watch(
      dbPlayingMediaProvider.selectAsync((st) => st?.path),
    );
    if (path == null || path.isEmpty) return null;
    // final videoController = VideoPlayerController.file(File(path));
    final mediaController = PlayerMediaController();
    await mediaController.mb_open(path);
    ref.onDispose(() {
      mediaController.mb_dispose();
    });
    //its neccessary to await initialize, otherwise aspectratio etc will wrong
    // await videoController.initialize();
    return mediaController;
  }
}
