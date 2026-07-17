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
  int? _prevId;

  @override
  Future<PlayerState?> build() async {
    final playingId = ref.watch(
      dbPrefProvider.select((av) => av.value?.playingId),
    );
    final isIdChanged = _prevId != playingId;
    _prevId = playingId;
    if (playingId == null) return null;
    final EnMedia? media = ref.watch(
      dbAlbumListProvider
          .select((av) => av.value ?? [])
          .select((al) => [for (final a in al) a.medias])
          .select((mll) => mll.expand((e) => e))
          .select((ml) => {for (final m in ml) m.id: m})
          .select((mm) => mm[playingId]),
    );
    if (media == null) return null;
    if (isIdChanged) {
      return PlayerState(
        title: media.name,
        sentenceCount: media.subtitles.firstOrNull?.sentences.length ?? 0,
        videoState: VideoState(
          repeat: false,
          showVolumeSlider: false,
          videoSliderDraggingValue: null,
          speed: 1,
          volume: 1,
          videoPath: media.path,
          isPlaying: true,
        ),
      );
    } else {
      return state.value?.copyWith(
        title: media.name,
        sentenceCount: media.subtitles.firstOrNull?.sentences.length ?? 0,
      );
    }
  }

  @override
  int? sentenceIdAtIndex(int i) {
    return _media?.subtitles.firstOrNull?.sentences.elementAtOrNull(i)?.id;
  }

  EnMedia? get _media {
    final playingId = ref.read(
      dbPrefProvider.select((av) => av.value?.playingId),
    );
    if (playingId == null) return null;
    final EnMedia? media = ref.read(
      dbAlbumListProvider
          .select((av) => av.value ?? [])
          .select((al) => [for (final a in al) a.medias])
          .select((mll) => mll.expand((e) => e))
          .select((ml) => {for (final m in ml) m.id: m})
          .select((mm) => mm[playingId]),
    );
    return media;
  }

  @override
  void play() {
    final val = state.value;
    if (val == null) return;
    state = AsyncData(
      val.copyWith(videoState: () => val.videoState?.copyWith(isPlaying: true)),
    );
  }
  @override
  void pause() {
    final val = state.value;
    if (val == null) return;
    state = AsyncData(
      val.copyWith(videoState: () => val.videoState?.copyWith(isPlaying: false)),
    );
  }


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
