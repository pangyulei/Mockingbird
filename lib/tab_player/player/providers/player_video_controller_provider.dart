
import 'dart:io';

import 'package:mockingbird/db/providers/db_playing_media_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'player_video_controller_provider.g.dart';
@riverpod
class PlayerVideoController extends _$PlayerVideoController {
  @override
  Future<VideoPlayerController?> build() async {
    // final String? path = (await ref.watch(dbPlayingMediaProvider.future))?.path;
    final String? path = await ref.watch(
      dbPlayingMediaProvider.selectAsync((st) => st?.path),
    );
    if (path == null || path.isEmpty) return null;
    final videoController = VideoPlayerController.file(File(path));
    ref.onDispose(() {
      videoController.dispose();
    });
    //its neccessary to await initialize, otherwise aspectratio etc will wrong
    await videoController.initialize();
    return videoController;
  }
}
