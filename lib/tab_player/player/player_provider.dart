import 'dart:io';

import 'package:mockingbird/db/providers/db_media_provider.dart';
import 'package:mockingbird/db/providers/db_pref_provider.dart';
import 'package:mockingbird/tab_player/player/player_state.dart';
import 'package:mockingbird/tab_player/player/player_ui.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:video_player/video_player.dart';

part 'player_provider.g.dart';

// name:'playingProvider'
@riverpod
class Player extends _$Player implements PlayerNotifierITF {
  int? _playingId;

  @override
  Future<PlayerState?> build() async {
    return null;
    // final playingId = await ref.watch(
    //   dbPrefProvider.selectAsync((s) => s.playingId),
    // );
    // final isIdChanged = _playingId != playingId;
    // _playingId = playingId;
    // if (playingId == null) return null;
    // final media = await ref.watch(dbMediaProvider(playingId).future);
    // if (media == null) return null;
    // if (isIdChanged) {
    //   final videoController = VideoPlayerController.file(File(media.path));
    //   await videoController.initialize();
    //   final duration = videoController.value.duration;
    //   videoController.dispose();

    //   return PlayerState(
    //     title: media.name,
    //     sentenceCount: media.subtitles.firstOrNull?.sentences.length ?? 0,
    //     videoState: VideoState(
    //       repeat: false,
    //       showVolumeSlider: false,
    //       videoSliderDraggingValue: null,
    //       positionMicro: 0,
    //       durationMicro: duration.inMicroseconds,
    //       speed: 1,
    //       volume: 1,
    //       videoPath: media.path,
    //       isPlaying: true,
    //     ),
    //   );
    // } else {
    //   return state.value?.copyWith(
    //     title: media.name,
    //     sentenceCount: media.subtitles.firstOrNull?.sentences.length ?? 0,
    //   );
    // }
  }

  @override
  int? sentenceIdAtIndex(int i) {
    // final mediaId = ref.read(dbPrefProvider).value?.playingId;
    // if (mediaId == null) return null;
    // final media = ref.read(dbMediaProvider(mediaId)).value;
    // return media?.subtitles.firstOrNull?.sentences.elementAtOrNull(i)?.id;
  }

  @override
  Future<void> play() async {}

  @override
  Future<void> pause() async {}

  void _onVideoPositionChanged(VideoPlayerController videoController) async {
    final data = state.value;
    if (data == null) return;
    final videoState = data.videoState;
    if (videoState == null) return;
    final position = videoController.value.position;
    final duration = videoController.value.duration;
    state = AsyncData(
      data.copyWith(
        videoState: () =>
            videoState.copyWith(positionMicro: position.inMicroseconds),
      ),
    );
    if (position >= duration) {
      //if video end of duration, play/pause button should update
      state = AsyncData(
        data.copyWith(videoState: () => videoState.copyWith(isPlaying: false)),
      );
    }
    //prevent videoController.play() but _state not setuped fully.
    if (data.sentenceCount == 0) return;
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
