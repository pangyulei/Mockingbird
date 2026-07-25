//seperate with videocontroller provider, so if you update media's name or its subtitle,
//the videocontroller wont rebuild

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockingbird/tab_player/player/providers/player_video_controller_provider.dart';
import 'package:mockingbird/tab_player/player/states/player_video.dart';
import 'package:video_player/video_player.dart';

final playerVideoProvider = AsyncNotifierProvider.autoDispose(
  PlayerVideoNotifier.new,
);

class PlayerVideoNotifier extends AsyncNotifier<PlayerVideo?> {
  @override
  Future<PlayerVideo?> build() async {
    //because of this is read and have to await, this has to be a AsyncNotifier
    final VideoPlayerController? videoController = await ref.watch(
      playerVideoControllerProvider.future,
    );
    if (videoController == null) return null;

    return PlayerVideo(
      positionMicro: 0,
      videoController: videoController,
      isPlaying: true,
    );
  }

  Future<void> play() async {
    state = AsyncData(state.value?.copyWith(isPlaying: true));
    await state.value?.videoController.play();
  }
  Future<void> pause() async {
    state = AsyncData(state.value?.copyWith(isPlaying: false));
    await state.value?.videoController.pause();
  }
  
  void updatePosition(Duration position) {
    state = AsyncData(state.value?.copyWith(positionMicro: position.inMicroseconds));
  }

  Future<void> seekTo(Duration position) async {
    await state.value?.videoController.seekTo(position);
  }

  Future<void> setSpeed(double speed) async {
    await state.value?.videoController.setPlaybackSpeed(speed);
  }

  Duration? get duration => state.value?.videoController.value.duration;
}
