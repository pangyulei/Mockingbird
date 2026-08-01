//seperate with videocontroller provider, so if you update media's name or its subtitle,
//the videocontroller wont rebuild

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockingbird/tab_player/player/providers/player_media_controller.dart';
import 'package:mockingbird/tab_player/player/providers/player_media_controller_provider.dart';
import 'package:mockingbird/tab_player/player/providers/player_setting_provider.dart';
import 'package:mockingbird/tab_player/player/states/player_media_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../tool/extensions.dart';

part 'player_media_provider.g.dart';

@riverpod
class PlayerMedia extends _$PlayerMedia {
  @override
  Future<PlayerMediaState> build() async {
    //because of this is read and have to await, this has to be a AsyncNotifier
    final mediaController = await ref.watch(
      playerVideoControllerProvider.future,
    );
    if (mediaController == null) return const PlayerMediaNull();
    final (speed, volume) = ref.read(
      playerSettingProvider.select((st) => (st.speed, st.volume)),
    );
    await mediaController.mb_setSpeed(speed);
    await mediaController.mb_setVolume(volume);
    //Fix playing media1, change to media2, it paused. because it didnt trigger listen,
    //I dont know why but we need to force it play
    await mediaController.mb_play();
    // ref.read(playerSubtitleProvider.notifier).scrollToTop();
    final sub = mediaController.mb_addListener(_mediaPositionChanged);
    _listen();
    ref.onDispose(() {
      sub.cancel();
    });
    return PlayerMediaData(
      positionMicro: 0,
      mediaController: mediaController,
      isPlaying: true,
    );
  }

  void _mediaPositionChanged(
    PlayerMediaControllerITF mediaController,
    Duration position,
  ) async {
    //for video slider moving along with playing
    var data = state.value;
    if (data is! PlayerMediaData) return;
    data = data.copyWith(positionMicro: position.inMicroseconds);
    state = AsyncData(data);

    final duration = mediaController.mb_duration;
    if (position >= duration) {
      //if video end of duration, play/pause button should update
      //feature: replay if auto play to end
      await play();
    }
  }

  void _listen() {
    debugPrint('listen added!');
    _listenToVolume();
    _listenToSpeed();
  }

  void _listenToSpeed() {
    ref.listen(playerSettingProvider.select((st) => st.speed), (
      previous,
      speed,
    ) async {
      await state.value?.as<PlayerMediaData>()?.mediaController.mb_setSpeed(
        speed,
      );
    });
  }

  void _listenToVolume() {
    ref.listen(playerSettingProvider.select((st) => st.volume), (
      previous,
      volume,
    ) async {
      await state.value?.as<PlayerMediaData>()?.mediaController.mb_setVolume(
        volume,
      );
    });
  }

  Future<void> play() async {
    var data = state.value;
    if (data is! PlayerMediaData) return;
    data = data.copyWith(isPlaying: true);
    state = AsyncData(data);
    await data.mediaController.mb_play();
  }

  Future<void> pause() async {
    var data = state.value;
    if (data is! PlayerMediaData) return;
    data = data.copyWith(isPlaying: false);
    state = AsyncData(data);
    await data.mediaController.mb_pause();
  }

  Future<void> seekTo(Duration position) async {
    await state.value?.as<PlayerMediaData>()?.mediaController.mb_seek(position);
  }

  Duration? get duration => state.value is PlayerMediaData
      ? (state.value as PlayerMediaData).mediaController.mb_duration
      : null;
}
