
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockingbird/db/providers/db_playing_media_provider.dart';
import 'package:video_player/video_player.dart';

final playerVideoControllerProvider = AsyncNotifierProvider(
  PlayerVideoControllerNotifier.new,
);

class PlayerVideoControllerNotifier extends AsyncNotifier<VideoPlayerController?> {
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
    await videoController.play();
    return videoController;
  }
}
