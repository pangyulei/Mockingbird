//seperate with videocontroller provider, so if you update media's name or its subtitle,
//the videocontroller wont rebuild

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockingbird/tab_player/player/providers/player_setting_provider.dart';
import 'package:mockingbird/tab_player/player/providers/player_video_controller_provider.dart';
import 'package:mockingbird/tab_player/player/states/player_media_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:video_player/video_player.dart';

import '../../../tool/extensions.dart';

part 'player_media_provider.g.dart';

@riverpod
class PlayerMedia extends _$PlayerMedia {
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
    //Fix playing media1, change to media2, it paused. because it didnt trigger listen,
    //I dont know why but we need to force it play
    await videoController.play();
    // ref.read(playerSubtitleProvider.notifier).scrollToTop();
    videoController.addListener(() => _videoPositionChanged(videoController));
    _listen();
    return PlayerMediaData(
      positionMicro: 0,
      videoController: videoController,
      isPlaying: true,
    );
  }

  void _videoPositionChanged(VideoPlayerController videoController) async {
    final position = videoController.value.position;
    //for video slider moving along with playing
    var data = state.value;
    if (data is! PlayerMediaData) return;
    data = data.copyWith(positionMicro: position.inMicroseconds);
    state = AsyncData(data);

    final duration = videoController.value.duration;
    if (position >= duration) {
      //if video end of duration, play/pause button should update
      await pause();
    }
  }

  void _listen() {
    debugPrint('listen added!');
    _listenToVolume();
    _listenToSpeed();
  }

  void _listenToSpeed() {
    ref.listen(playerSettingProvider.select((st) => st.value?.speed), (
      previous,
      speed,
    ) async {
      if (speed == null) return;
      await state.value?.as<PlayerMediaData>()?.videoController.setPlaybackSpeed
        (speed);
    });
  }

  void _listenToVolume() {
    ref.listen(playerSettingProvider.select((st) => st.value?.volume), (
      previous,
      volume,
    ) async {
      if (volume == null) return;
      await state.value?.as<PlayerMediaData>()?.videoController.setVolume(volume);
    });
  }

  Future<void> play() async {
    var data = state.value;
    if (data is! PlayerMediaData) return;
    data = data.copyWith(isPlaying: true);
    state = AsyncData(data);
    await data.videoController.play();
  }

  Future<void> pause() async {
    var data = state.value;
    if (data is! PlayerMediaData) return;
    data = data.copyWith(isPlaying: false);
    state = AsyncData(data);
    await data.videoController.pause();
  }

  Future<void> seekTo(Duration position) async {
    await state.value?.as<PlayerMediaData>()?.videoController.seekTo(position);
  }

  Duration? get duration => state.value is PlayerMediaData
      ? (state.value as PlayerMediaData).videoController.value.duration
      : null;
}
