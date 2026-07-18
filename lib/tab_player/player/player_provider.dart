import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockingbird/db/entities/en_media.dart';
import 'package:mockingbird/db/providers/db_album_list_provider.dart';
import 'package:mockingbird/db/providers/db_pref_provider.dart';
import 'package:mockingbird/tab_player/player/player_state.dart';
import 'package:mockingbird/tab_player/player/player_ui.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:video_player/video_player.dart';

part 'player_provider.g.dart';

// name:'playingProvider'
@riverpod
class Player extends _$Player implements PlayerNotifierITF {
  @override
  PlayerState? build() {
    final videoState = ref.watch(playerVideoProvider(videoPositionChanged));
    if (videoState == null) return null;
    final playingMedia = ref.watch(playerMediaProvider);
    if (playingMedia == null) return null;
    return PlayerState(
      title: playingMedia.name,
      sentenceCount: playingMedia.subtitles.firstOrNull?.sentences.length ?? 0,
      videoState: videoState,
    );
  }

  @override
  int? sentenceIdAtIndex(int i) {
    final media = ref.read(playerMediaProvider);
    return media?.subtitles.firstOrNull?.sentences.elementAtOrNull(i)?.id;
  }

  @override
  Future<void> decSpeed() async {
    final currSpeed = state?.videoState?.speed ?? 1;
    final double nextSpeed = (currSpeed - _kStepPlaySpeed).clamp(
      _kMinPlaySpeed,
      _kMaxPlaySpeed,
    );
    state = state?.copyWith(
      videoState: () => state?.videoState?.copyWith(speed: nextSpeed),
    );
    await state?.videoState?.controller.setPlaybackSpeed(nextSpeed);
  }

  @override
  Future<void> incSpeed() async {
    final currSpeed = state?.videoState?.speed ?? 1;
    final double nextSpeed = (currSpeed + _kStepPlaySpeed).clamp(
      _kMinPlaySpeed,
      _kMaxPlaySpeed,
    );
    state = state?.copyWith(
      videoState: () => state?.videoState?.copyWith(speed: nextSpeed),
    );
    await state?.videoState?.controller.setPlaybackSpeed(nextSpeed);
  }

  @override
  Future<void> resetSpeed() async {
    final nextSpeed = (1.0).clamp(_kMinPlaySpeed, _kMaxPlaySpeed);
    state = state?.copyWith(
      videoState: () => state?.videoState?.copyWith(speed: nextSpeed),
    );
    await state?.videoState?.controller.setPlaybackSpeed(nextSpeed);
  }

  @override
  Future<void> play() async {
    state = state?.copyWith(
      videoState: () => state?.videoState?.copyWith(isPlaying: true),
    );
    await state?.videoState?.controller.play();
  }

  @override
  Future<void> pause() async {
    state = state?.copyWith(
      videoState: () => state?.videoState?.copyWith(isPlaying: false),
    );
    await state?.videoState?.controller.pause();
  }

  @override
  void videoPositionChanged(VideoPlayerController videoController) async {
    final state = this.state;
    if (state == null) return;
    // final position = videoController.value.position;
    // final duration = videoController.value.duration;
    // if (position >= duration) {
    //   //if video end of duration, play/pause button should update
    // }
    //prevent videoController.play() but _state not setuped fully.
    if (state.sentenceCount == 0) return;
    // final media = _media;
    // if (media == null) {
    //   debugPrint('media not found');
    //   return;
    // }
    // final subtitle = media.subtitles.firstOrNull;
    // if (subtitle == null || subtitle.sentences.isEmpty) {
    //   debugPrint('no subtitle to spot');
    //   return;
    // }
    // final sentences = subtitle.sentences;
    // if (_state.repeat) {
    //   //if repeat one is turn on, while sentence finished, seek to beginning
    //   final playingIndex = _state.focusedIndex;
    //   final isDraggingSlider = _state.videoSliderDraggingValue != null;
    //   debugPrint('repeat $playingIndex $isDraggingSlider');
    //   if (playingIndex != null && !isDraggingSlider) {
    //     final sentence = sentences[playingIndex];
    //     if (position > sentence.end) {
    //       debugPrint('positon changed, repeat index: $playingIndex');
    //       await videoController.seekTo(sentence.start);
    //     }
    //   }
    // } else {
    //   //according to position, find current matched sentence index, marked as playingIndex
    //   final playingIndex = _playingIndexByPosition(position);
    //   final uiPlayingIndex = _state.focusedIndex;
    //   //scroll to playingIndex and focus it
    //   if (playingIndex != uiPlayingIndex) {
    //     debugPrint('playingindex $playingIndex uiPlayingIndex $uiPlayingIndex');
    //     //只有循環的時候，才需要持續自動滾動到當前句
    //     if (playingIndex == null) {
    //       _scrollController._scrollTo(_state.sentenceStates.length - 1);
    //     } else {
    //       _scrollController._scrollTo(playingIndex);
    //     }
    //     setState(() {
    //       _state = _state.focus(playingIndex);
    //     });
    //   }
    // }
  }
}

@riverpod
class PlayerVideo extends _$PlayerVideo {
  @override
  PlayerVideoState? build(void Function(VideoPlayerController) listener) {
    final videoController = ref.watch(
      playerVideoControllerProvider(listener).select((av) => av.value),
    );
    if (videoController == null) return null;
    videoController.play();
    return PlayerVideoState(
      repeat: false,
      showVolumeSlider: false,
      controller: videoController,
      videoSliderDraggingValue: null,
      isPlaying: true,
      speed: 1,
      volume: 1,
    );
  }
}

@riverpod
class PlayerVideoController extends _$PlayerVideoController {
  @override
  Future<VideoPlayerController?> build(
    void Function(VideoPlayerController) listener,
  ) async {
    final String? playingMediaPath = ref.watch(
      playerMediaProvider.select((m) => m?.path),
    );
    if (playingMediaPath == null) return null;
    final videoController = VideoPlayerController.file(File(playingMediaPath));
    await videoController.initialize();
    videoController.addListener(() => listener(videoController));
    ref.onDispose(() {
      videoController.dispose();
    });
    return videoController;
  }
}

@riverpod
class PlayerMedia extends _$PlayerMedia {
  @override
  EnMedia? build() {
    final playingId = ref.watch(
      dbPrefProvider.select((av) => av.value?.playingId),
    );
    if (playingId == null) return null;
    final EnMedia? media = ref.watch(
      dbAlbumListProvider
          .select((av) => av.value ?? [])
          .select((al) => [for (final a in al) a.medias])
          .select((mll) => mll.expand((e) => e))
          .select((ml) => {for (final m in ml) m.id: m})
          .select((mm) => mm[playingId]),
    );
    return media;
  }
}

const double _kMaxPlaySpeed = 3.0;
const double _kMinPlaySpeed = 0.25;
const double _kStepPlaySpeed = 0.25;
