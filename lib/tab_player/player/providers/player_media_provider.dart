//seperate with videocontroller provider, so if you update media's name or its subtitle,
//the videocontroller wont rebuild

import 'package:defer/defer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockingbird/tab_player/player/providers/player_setting_provider.dart';
import 'package:mockingbird/tab_player/player/providers/player_subtitle_provider.dart';
import 'package:mockingbird/tab_player/player/providers/player_video_controller_provider.dart';
import 'package:mockingbird/tab_player/player/states/player_video.dart';
import 'package:video_player/video_player.dart';

final playerMediaProvider = AsyncNotifierProvider.autoDispose(
  PlayerMediaNotifier.new,
);

class PlayerMediaNotifier extends AsyncNotifier<PlayerMediaState> {
  bool _isDraggingVideoSlider = false;
  int? _prevPlayingSentenceIndex;

  @override
  Future<PlayerMediaState> build() async {
    //because of this is read and have to await, this has to be a AsyncNotifier
    final VideoPlayerController? videoController = await ref.watch(
      playerVideoControllerProvider.future,
    );
    if (videoController == null) return const PlayerMediaNull();
    final setting = await ref.read(playerSettingProvider.future);
    await videoController.setPlaybackSpeed(setting.speed);
    await videoController.setVolume(setting.volume);
    // await videoController.play();
    _listen();
    return PlayerMediaData(
      positionMicro: 0,
      videoController: videoController,
      isPlaying: true,
    );
  }

  void _listen() {
    _listenToPlayOrPause();
    _listenToVolume();
    _listenToSpeed();
  }

  void _listenToSpeed() {
    ref.listen(playerSettingProvider.select((st) => st.value?.speed), (
      previous,
      speed,
    ) async {
      if (speed == null) return;
      final data = state.value;
      if (data is! PlayerMediaData) return;
      await data.videoController.setPlaybackSpeed(speed);
    });
  }

  void _listenToVolume() {
    ref.listen(playerSettingProvider.select((st) => st.value?.volume), (
      previous,
      volume,
    ) async {
      if (volume == null) return;
      final data = state.value;
      if (data is! PlayerMediaData) return;
      await data.videoController.setVolume(volume);
    });
  }

  void _listenToPlayOrPause() {
    //play or pause
    ref.listen(
      playerMediaProvider.select((st) {
        final data = st.value;
        return data is PlayerMediaData ? data.isPlaying : null;
      }),
      (previous, isPlaying) async {
        if (isPlaying == null) return;
        final data = state.value;
        if (data is! PlayerMediaData) return;
        if (isPlaying) {
          await data.videoController.play();
        } else {
          await data.videoController.pause();
        }
      },
    );
  }

  void play() {
    var data = state.value;
    if (data is! PlayerMediaData) return;
    data = data.copyWith(isPlaying: true);
    state = AsyncData(data);
    // await data.videoController.play();
  }

  void pause() {
    var data = state.value;
    if (data is! PlayerMediaData) return;
    data = data.copyWith(isPlaying: false);
    state = AsyncData(data);
    // await data.videoController.pause();
  }

  Future<void> seekTo(Duration position) async {
    var data = state.value;
    if (data is! PlayerMediaData) return;
    await data.videoController.seekTo(position);
  }

  // Future<void> updateSpeed(double speed) async {
  //   var data = state.value;
  //   if (data is! PlayerMediaData) return;
  //   await data.videoController.setPlaybackSpeed(speed);
  // }

  // Future<void> updateVolume(double volume) async {
  //   var data = state.value;
  //   if (data is! PlayerMediaData) return;
  //   await data.videoController.setVolume(volume);
  // }

  Duration? get duration {
    var data = state.value;
    if (data is! PlayerMediaData) return null;
    return data.videoController.value.duration;
  }

  Future<void> videoPositionChanged(
    VideoPlayerController videoController,
  ) async {
    final position = videoController.value.position;
    //for video slider moving along with playing
    var data = state.value;
    if (data is! PlayerMediaData) return;
    data = data.copyWith(positionMicro: position.inMicroseconds);
    state = AsyncData(data);

    final int? playingSentenceIndex = ref
        .read(playerSubtitleProvider.notifier)
        .playingSentenceIndex;
    final bool isSentenceChanged =
        playingSentenceIndex != _prevPlayingSentenceIndex;

    final duration = videoController.value.duration;
    if (position >= duration) {
      //if video end of duration, play/pause button should update
      pause();
    }
    //prevent videoController.play() but _state not setuped fully.
    final isLoop = ref.read(
      playerSettingProvider.select((st) => st.value?.isLoop ?? false),
    );
    //handle scroll
    if (isSentenceChanged) {
      if (_isDraggingVideoSlider) {
        ref.read(playerSubtitleProvider.notifier).jumpToPlayingSentence();
      } else if (!isLoop) {
        //playing auto scroll to next sentence, not for loop mode
        ref.read(playerSubtitleProvider.notifier).scrollToPlayingSentence();
      }
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
    _prevPlayingSentenceIndex = playingSentenceIndex;
  }

  Future<void> videoSliderStartChanged(double valMicro) async {
    _isDraggingVideoSlider = true;
    debugPrint('slider: start');
    pause();
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
        final loopSentence = ref
            .read(playerSubtitleProvider.notifier)
            .loopSentence;
        final Duration seekToPosition = loopSentence == null
            ? position
            : loopSentence.start;
        await seekTo(seekToPosition);

        final duration = this.duration;
        if (duration != null && seekToPosition < duration) {
          debugPrint('slider: play');
          play();
        }
      },
    );
  }
}
