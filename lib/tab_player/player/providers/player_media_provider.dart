//seperate with videocontroller provider, so if you update media's name or its subtitle,
//the videocontroller wont rebuild

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockingbird/db/providers/db_playing_media_provider.dart';
import 'package:mockingbird/tab_player/player/player_media_controller.dart';
import 'package:mockingbird/tab_player/player/providers/player_media_controller_provider.dart';
import 'package:mockingbird/tab_player/player/providers/player_setting_provider.dart';
import 'package:mockingbird/tab_player/player/states/player_media_state.dart';

import '../../../tool/extensions.dart';

final playerMediaProvider = AsyncNotifierProvider.autoDispose(
  PlayerMediaNotifier.new,
);

class PlayerMediaNotifier extends AsyncNotifier<PlayerMediaState> {
  final _subs = <StreamSubscription>[];

  @override
  Future<PlayerMediaState> build() async {
    ref.onDispose(() {
      for (final sub in _subs) {
        sub.cancel();
      }
    });
    final media = (await ref.watch(dbPlayingMediaProvider.future));
    if (media == null) return const PlayerMediaNull();
    //because of this is read and have to await, this has to be a AsyncNotifier
    final mediaController = ref.watch(playerMediaControllerProvider);
    await mediaController.open(media);
    debugPrint('${mediaController.duration}');
    final (speed, volume) = ref.read(
      playerSettingProvider.select((st) => (st.speed, st.volume)),
    );
    await mediaController.setSpeed(speed);
    await mediaController.setVolume(volume);
    //Fix playing media1, change to media2, it paused. because it didnt trigger listen,
    //I dont know why but we need to force it play
    await mediaController.play();
    // ref.read(playerSubtitleProvider.notifier).scrollToTop();
    _subs.add(mediaController.listenPosition(_mediaPositionChanged));
    _subs.add(
      mediaController.listenDuration((_, duration) async {
        var data = await future;
        if (data is PlayerMediaData) {
          state = AsyncData(data.copyWith(duration: duration));
        }
      }),
    );
    _listen();
    return PlayerMediaData(
      position: mediaController.position,
      duration: mediaController.duration,
      mediaController: mediaController,
      playing: true,
    );
  }

  void _mediaPositionChanged(
    PlayerMediaControllerITF mediaController,
    Duration position,
  ) async {
    final duration = mediaController.duration;
    if (position >= duration) {
      //if video end of duration, play/pause button should update
      //feature: replay if auto play to end
      await seek(const Duration(seconds: 0));
      await play();
    }
    //for video slider moving along with playing
    var data = await future;
    if (data is PlayerMediaData) {
      state = AsyncData(data.copyWith(position: position));
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
      await state.value?.as<PlayerMediaData>()?.mediaController.setSpeed(speed);
    });
  }

  void _listenToVolume() {
    ref.listen(playerSettingProvider.select((st) => st.volume), (
      previous,
      volume,
    ) async {
      await state.value?.as<PlayerMediaData>()?.mediaController.setVolume(
        volume,
      );
    });
  }

  Future<void> play() async {
    var data = state.value;
    if (data is! PlayerMediaData) return;
    data = data.copyWith(playing: true);
    state = AsyncData(data);
    debugPrint(
      'play ${data.mediaController.position} ${data.mediaController.duration}',
    );
    if (data.mediaController.position >= data.mediaController.duration) {
      await data.mediaController.seek(const Duration(seconds: 0));
    }
    await data.mediaController.play();
  }

  Future<void> pause() async {
    var data = state.value;
    if (data is! PlayerMediaData) return;
    data = data.copyWith(playing: false);
    state = AsyncData(data);
    await data.mediaController.pause();
  }

  Future<void> seek(Duration position) async {
    await state.value?.as<PlayerMediaData>()?.mediaController.seek(position);
  }

  Duration? get duration => state.value is PlayerMediaData
      ? (state.value as PlayerMediaData).mediaController.duration
      : null;
}
