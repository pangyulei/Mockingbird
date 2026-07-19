import 'dart:io';

import 'package:collection/collection.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockingbird/db/entities/en_media.dart';
import 'package:mockingbird/db/entities/en_sentence.dart';
import 'package:mockingbird/db/providers/db_album_list_provider.dart';
import 'package:mockingbird/db/providers/db_pref_provider.dart';
import 'package:mockingbird/tab_player/player/player_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:video_player/video_player.dart';

import '../../tool/subtitle_parser.dart';

part 'player_provider.g.dart';

@riverpod
class Player extends _$Player {
  PlayerVideoState? get _videoState => state?.videoState;

  VideoPlayerController? get _videoController => state?.videoState?.controller;
  ItemScrollController? get _scrollController => state?.scrollController;

  int? _prevPlayingSentenceIndex;
  bool _isDraggingVideoSlider = false;

  @override
  PlayerState? build() {
    final videoState = ref.watch(playerVideoProvider);
    if (videoState == null) return null;
    final playingMedia = ref.watch(playerMediaProvider);
    if (playingMedia == null) return null;
    final sentenceList = playingMedia.subtitles.firstOrNull?.sentences;
    return PlayerState(
      title: playingMedia.name,
      sentenceCount: sentenceList?.length ?? 0,
      videoState: videoState,
      scrollController: ItemScrollController(),
      playingSentenceId: sentenceList?.isEmpty == true ? null : 0,
    );
  }

  void _updateVideoState(PlayerVideoState? videoState) {
    if (videoState != null) {
      debugPrint(
        'update position to ${Duration(microseconds: videoState.positionMicro)}',
      );
    } else {
      debugPrint('update position to null');
    }
    state = state?.copyWith(videoState: () => videoState);
  }

  void tapSentence(int? sentenceId) async {
    final videoController = _videoController;
    if (videoController == null) return;
    final videoState = _videoState;
    if (videoState == null) return;
    final media = ref.read(playerMediaProvider);
    final entry = media?.subtitles.firstOrNull?.sentences
        .asMap()
        .entries
        .firstWhereOrNull((e) => e.value.id == sentenceId);
    final index = entry?.key;
    final sentence = entry?.value;
    if (index == null || sentence == null) return;

    _scrollController?._scrollTo(index);
    if (videoState.loop) {
      _updateVideoState(videoState.copyWith(loopingIndex: () => index));
    }
    await videoController.seekTo(sentence.start);
    await videoController.play();
  }

  int? sentenceIdAtIndex(int i) {
    final media = ref.read(playerMediaProvider);
    return media?.subtitles.firstOrNull?.sentences.elementAtOrNull(i)?.id;
  }

  void scrollToTop() {
    _scrollController?._scrollTo(0);
  }

  void scrollToPlayingSentence() {
    final sentenceList = ref
        .read(playerMediaProvider)
        ?.subtitles
        .firstOrNull
        ?.sentences;
    if (sentenceList == null || sentenceList.isEmpty) return;
    final position = _videoState?.positionMicro;
    if (position == null) return;
    final playingSentenceIndex = _sentenceIndexByPosition(
      Duration(microseconds: position),
    );
    if (playingSentenceIndex == null) return;
    _scrollController?._scrollTo(playingSentenceIndex);
  }

  void scrollToBottom() {
    final sentenceList = ref
        .read(playerMediaProvider)
        ?.subtitles
        .firstOrNull
        ?.sentences;
    if (sentenceList == null || sentenceList.isEmpty) return;
    _scrollController?._scrollTo(sentenceList.length - 1);
  }

  Future<void> decSpeed() async {
    final currSpeed = state?.videoState?.speed ?? 1;
    final double nextSpeed = (currSpeed - _kStepPlaySpeed).clamp(
      _kMinPlaySpeed,
      _kMaxPlaySpeed,
    );
    _updateVideoState(_videoState?.copyWith(speed: nextSpeed));
    await _videoController?.setPlaybackSpeed(nextSpeed);
  }

  Future<void> incSpeed() async {
    final currSpeed = state?.videoState?.speed ?? 1;
    final double nextSpeed = (currSpeed + _kStepPlaySpeed).clamp(
      _kMinPlaySpeed,
      _kMaxPlaySpeed,
    );
    _updateVideoState(_videoState?.copyWith(speed: nextSpeed));
    await _videoController?.setPlaybackSpeed(nextSpeed);
  }

  Future<void> resetSpeed() async {
    final nextSpeed = (1.0).clamp(_kMinPlaySpeed, _kMaxPlaySpeed);
    _updateVideoState(_videoState?.copyWith(speed: nextSpeed));
    await _videoController?.setPlaybackSpeed(nextSpeed);
  }

  Future<void> play() async {
    _updateVideoState(_videoState?.copyWith(isPlaying: true));
    await _videoController?.play();
  }

  Future<void> pause() async {
    _updateVideoState(_videoState?.copyWith(isPlaying: false));
    await _videoController?.pause();
  }

  void loop() {
    final position = _videoState?.positionMicro;
    if (position == null) return;
    final playingSentenceIndex = _sentenceIndexByPosition(
      Duration(microseconds: position),
    );
    _updateVideoState(
      _videoState?.copyWith(
        loopingIndex: () => playingSentenceIndex,
        loop: true,
      ),
    );
  }

  void unloop() {
    _updateVideoState(
      _videoState?.copyWith(loopingIndex: () => null, loop: false),
    );
  }

  Future<void> videoPositionChanged(
    VideoPlayerController videoController,
  ) async {
    final state = this.state;
    final videoState = state?.videoState;
    if (state == null || videoState == null) return;
    if (_isDraggingVideoSlider) return;
    final position = videoController.value.position;
    //for video slider moving along with playing
    _updateVideoState(
      videoState.copyWith(positionMicro: position.inMicroseconds),
    );
    final duration = videoController.value.duration;
    if (position >= duration) {
      //if video end of duration, play/pause button should update
      _updateVideoState(videoState.copyWith(isPlaying: false));
    }
    //prevent videoController.play() but _state not setuped fully.
    if (state.sentenceCount == 0) return;
    final sentenceList = ref
        .read(playerMediaProvider)
        ?.subtitles
        .firstOrNull
        ?.sentences;
    if (sentenceList == null || sentenceList.isEmpty) return;

    final playingSentenceIndex = _sentenceIndexByPosition(position);
    final playingSentence = playingSentenceIndex == null
        ? null
        : sentenceList.elementAtOrNull(playingSentenceIndex);
    final isSentenceChanged = playingSentenceIndex != _prevPlayingSentenceIndex;

    //debug message
    // final prev = _prevPlayingSentenceIndex == null
    //     ? null
    //     : sentenceList[_prevPlayingSentenceIndex!];
    // final now = playingSentenceIndex == null ? null : sentenceList[playingSentenceIndex];
    // debugPrint('$prev => $now');
    //handle mark
    if (isSentenceChanged) {
      debugPrint('positon changing mark $playingSentence');
      _markSentence(playingSentenceIndex);
    }

    //handle scroll
    if (!videoState.loop && isSentenceChanged) {
      debugPrint(
        'positon changing scrollto ${playingSentence ?? sentenceList.last}',
      );
      _scrollController?._scrollTo(
        playingSentenceIndex ?? sentenceList.length - 1,
      );
    }
    //handle loop seek to begin
    final loopingIndex = videoState.loopingIndex;
    if (videoState.loop && loopingIndex != null) {
      //if repeat one is turn on, while sentence finished, seek to beginning
      final sentence = sentenceList.elementAtOrNull(loopingIndex);
      debugPrint('position changing loop $sentence');
      if (sentence != null && position > sentence.end) {
        debugPrint('positon changing loop seek to ${sentence.start}');
        await videoController.seekTo(sentence.start);
      }
    }
    _prevPlayingSentenceIndex = playingSentenceIndex;
  }

  void _markSentence(int? index) {
    final sentenceList = ref
        .read(playerMediaProvider)
        ?.subtitles
        .firstOrNull
        ?.sentences;
    if (sentenceList == null || sentenceList.isEmpty) return;
    if (index == null) {
      state = state?.copyWith(playingSentenceId: () => null);
    } else {
      int? id = sentenceList.elementAtOrNull(index)?.id;
      state = state?.copyWith(playingSentenceId: () => id);
    }
  }

  int? _sentenceIndexByPosition(Duration position) {
    final sentenceList = ref
        .read(playerMediaProvider)
        ?.subtitles
        .firstOrNull
        ?.sentences;
    if (sentenceList == null || sentenceList.isEmpty) return null;
    for (int i = 0; i < sentenceList.length; i++) {
      EnSentence? prev = i == 0 ? null : sentenceList[i - 1];
      EnSentence? next = sentenceList.elementAtOrNull(i + 1);
      EnSentence sentence = sentenceList[i];
      if (sentence.isPlaying(prev, next, position)) {
        return i;
      }
    }
    return null;
  }

  Future<void> _syncVideoWithSlider(Duration position) async {
    final sentenceList = ref
        .read(playerMediaProvider)
        ?.subtitles
        .firstOrNull
        ?.sentences;
    if (sentenceList == null || sentenceList.isEmpty) return;
    final playingSentenceIndex = _sentenceIndexByPosition(position);
    if (_videoState?.loop == true) {
      debugPrint(
        'sliding loop ${ref.read(playerMediaProvider)?.subtitles.firstOrNull?.sentences.elementAtOrNull(playingSentenceIndex ?? 9999)}',
      );
      _updateVideoState(
        _videoState?.copyWith(loopingIndex: () => playingSentenceIndex),
      );
    }
    final playingSentence = playingSentenceIndex == null
        ? null
        : sentenceList.elementAtOrNull(playingSentenceIndex);
    debugPrint('sliding jumpto ${playingSentence ?? sentenceList.last}');
    _markSentence(playingSentenceIndex);
    if (playingSentenceIndex == null) {
      _scrollController?._scrollTo(sentenceList.length - 1);
    } else {
      _scrollController?._jumpTo(playingSentenceIndex);
    }
    _updateVideoState(
      _videoState?.copyWith(positionMicro: position.inMicroseconds),
    );
    await _videoController?.seekTo(position);
  }

  Future<void> videoSliderStartChanged(double valMicro) async {
    _isDraggingVideoSlider = true;
    debugPrint('start of slide: pause');
    _updateVideoState(_videoState?.copyWith(isPlaying: false));
    await _videoController?.pause();

    await _syncVideoWithSlider(Duration(microseconds: valMicro.toInt()));
  }

  Future<void> videoSliderChanging(double valMicro) async {
    // debugPrint('videoSliderChanging $valMicro');
    await _syncVideoWithSlider(Duration(microseconds: valMicro.toInt()));
  }

  Future<void> videoSliderEndChanged(double valMicro) async {
    final videoController = _videoController;
    final sentenceList = ref
        .read(playerMediaProvider)
        ?.subtitles
        .firstOrNull
        ?.sentences;
    if (videoController == null ||
        sentenceList == null ||
        sentenceList.isEmpty) {
      _isDraggingVideoSlider = false;
      return;
    }
    final duration = videoController.value.duration;
    final position = Duration(microseconds: valMicro.toInt());
    //seek to sentence start
    final Duration seekTo;
    final playingSentenceIndex = _sentenceIndexByPosition(position);
    if (_videoState?.loop == true) {
      final playingSentence = playingSentenceIndex == null
          ? null
          : sentenceList.elementAtOrNull(playingSentenceIndex);
      seekTo = playingSentence == null ? position : playingSentence.start;
    } else {
      seekTo = position;
    }

    await _syncVideoWithSlider(seekTo);
    if (seekTo < duration) {
      debugPrint('end of slide: play');
      _updateVideoState(_videoState?.copyWith(isPlaying: true));
      await _videoController?.play();
    } else {
      // _updateVideoState(
      //   _videoState?.copyWith(positionMicro: seekTo.inMicroseconds),
      // );
    }
    debugPrint('end of slide: isdragging false');
    _isDraggingVideoSlider = false;
  }

  Future<void> updateVolume(double newVolume) async {
    _updateVideoState(_videoState?.copyWith(volume: newVolume));
    await _videoController?.setVolume(newVolume);
  }

  void volumeTapped() {
    final visible = state?.videoState?.showVolumeSlider;
    if (visible == null) return;
    _updateVideoState(_videoState?.copyWith(showVolumeSlider: !visible));
  }

  Future<void> addSubtitle() async {
    final media = ref.read(playerMediaProvider);
    if (media == null) return;
    final subtitlePath = await _pickOneSubtitle();
    if (subtitlePath == null) return;

    EasyLoading.show(maskType: .clear);
    final subtitle = await SubtitleParser.parsePath(subtitlePath);
    if (subtitle != null) {
      await ref.read(dbAlbumListProvider.notifier).addSubtitle(media, subtitle);
    }
    EasyLoading.dismiss();
  }

  Future<String?> _pickOneSubtitle() async {
    try {
      final pickedFiles = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: [...kSubtitleExtensions],
        allowMultiple: false,
      );
      final subtitlePath = pickedFiles?.files
          .firstWhereOrNull(
            (f) =>
                kSubtitleExtensions.contains(f.extension?.toLowerCase() ?? ''),
          )
          ?.path;
      return subtitlePath;
    } catch (e) {
      debugPrint('Error adding subtitle: $e');
      return null;
    }
  }
}

@riverpod
class PlayerVideo extends _$PlayerVideo {
  @override
  PlayerVideoState? build() {
    final videoController = ref.watch(
      playerVideoControllerProvider.select((av) => av.value),
    );
    if (videoController == null) return null;
    videoController.play();
    return PlayerVideoState(
      positionMicro: 0,
      loopingIndex: null,
      loop: false,
      showVolumeSlider: false,
      controller: videoController,
      isPlaying: true,
      speed: 1,
      volume: 1,
    );
  }
}

@riverpod
class PlayerVideoController extends _$PlayerVideoController {
  @override
  Future<VideoPlayerController?> build() async {
    final String? path = ref.watch(playerMediaProvider.select((m) => m?.path));
    if (path == null || path.isEmpty) return null;
    final videoController = VideoPlayerController.file(File(path));
    await videoController.initialize();
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

extension on EnSentence {
  bool isPlaying(EnSentence? prev, EnSentence? next, Duration position) {
    //刚开始的时候position=0,但是第一句话的start不一定是0
    //所以当position=0的时候，就不处于任何一句话的区间，这里直接做个判断就省了后面的几百句话的遍历
    final start = prev == null ? const Duration(microseconds: 0) : this.start;
    if (next == null) {
      return start <= position && position <= end;
    } else {
      return start <= position && position < next.start;
    }
  }
}

extension on ItemScrollController {
  void _jumpTo(int index) {
    if (isAttached) {
      jumpTo(index: index, alignment: index == 0 ? 0 : 0.3);
    } else {
      debugPrint('${identityHashCode(this)} jump fail, scroll is not attached');
    }
  }

  void _scrollTo(int index) {
    if (isAttached) {
      scrollTo(
        index: index,
        duration: const Duration(milliseconds: 250),
        alignment: index == 0 ? 0 : 0.3,
      );
    } else {
      debugPrint(
        '${identityHashCode(this)} scroll fail, scroll is not attached',
      );
    }
  }
}
