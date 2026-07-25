//seperate with videocontroller provider, so if you update media's name or its subtitle,
//the videocontroller wont rebuild

import 'package:defer/defer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockingbird/tab_player/player/providers/player_setting_provider.dart';
import 'package:mockingbird/tab_player/player/providers/player_subtitle_provider.dart';
import 'package:mockingbird/tab_player/player/providers/player_video_controller_provider.dart';
import 'package:mockingbird/tab_player/player/states/player_video.dart';
import 'package:video_player/video_player.dart';

final playerVideoProvider = AsyncNotifierProvider.autoDispose(
  PlayerVideoNotifier.new,
);

class PlayerVideoNotifier extends AsyncNotifier<PlayerVideo?> {
  bool _isDraggingVideoSlider = false;

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

  Future<void> seekTo(Duration position) async {
    await state.value?.videoController.seekTo(position);
  }

  Future<void> setSpeed(double speed) async {
    await state.value?.videoController.setPlaybackSpeed(speed);
  }

  Duration? get duration => state.value?.videoController.value.duration;

  Future<void> videoPositionChanged(
      VideoPlayerController videoController,
      ) async {
    final position = videoController.value.position;
    //for video slider moving along with playing
    state = AsyncData(state.value?.copyWith(positionMicro: position.inMicroseconds));

    final duration = videoController.value.duration;
    if (position >= duration) {
      //if video end of duration, play/pause button should update
      await pause();
    }
    //prevent videoController.play() but _state not setuped fully.
    final isLoop = ref.read(playerSettingProvider.select((st)=>st.value?.isLoop ?? false));
    if (_isDraggingVideoSlider) {
      ref.read(playerSubtitleProvider.notifier).jumpToPlayingSentence();
    } else if (!isLoop) {
      //playing auto scroll to next sentence, not for loop mode
      ref.read(playerSubtitleProvider.notifier).scrollToPlayingSentence();
    }
    //handle loop seek to begin
    final loopSentence = ref.read(playerSubtitleProvider.notifier).loopSentence;
    if (!_isDraggingVideoSlider && loopSentence != null) {
      //if repeat one is turn on, while sentence finished, seek to beginning
      // debugPrint('position changing loop $sentence');
      if (position > loopSentence.end) {
        // debugPrint('positon changing loop seek to ${sentence.start}');
        await videoController.seekTo(loopSentence.start);
      }
    }
  }

  Future<void> videoSliderStartChanged(double valMicro) async {
    _isDraggingVideoSlider = true;
    debugPrint('slider: start');
    await pause();
    final position = Duration(microseconds: valMicro.toInt());
    await seekTo(position);
  }

  Future<void> videoSliderChanging(double valMicro) async {
    final position = Duration(microseconds: valMicro.toInt());
    await seekTo(position);
  }

  Future<void> videoSliderEndChanged(double valMicro) async {
    await defer(
          () async {
        _isDraggingVideoSlider = false;
        debugPrint('slider: end');
      },
          () async {
        final position = Duration(microseconds: valMicro.toInt());
        //seek to sentence start
        final loopSentence = ref.read(playerSubtitleProvider.notifier).loopSentence;
        final Duration seekToPosition = loopSentence == null ? position : loopSentence.start;
        await seekTo(seekToPosition);

        final duration = this.duration;
        if (duration != null && seekToPosition < duration) {
          debugPrint('slider: play');
          await play();
        }
      },
    );
  }
}
