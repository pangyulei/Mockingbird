import 'dart:io';

import 'package:collection/collection.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockingbird/db/entities/en_media.dart';
import 'package:mockingbird/db/entities/en_sentence.dart';
import 'package:mockingbird/db/providers/db_album_list_provider.dart';
import 'package:mockingbird/db/providers/db_playing_media_provider.dart';
import 'package:mockingbird/db/providers/db_pref_provider.dart';
import 'package:mockingbird/tab_player/player/player_state.dart';
import 'package:mockingbird/tool/extensions.dart';
import 'package:mockingbird/tool/ui_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:video_player/video_player.dart';

import '../../tool/subtitle_parser.dart';

part 'player_provider.g.dart';

@riverpod
class Player extends _$Player {
  PlayerVideoState? get _videoState => state.data?.videoState;

  VideoPlayerController? get _videoController => _videoState?.controller;

  ItemScrollController? get _scrollController => state.data?.scrollController;

  int? _prevPlayingSentenceIndex;
  bool _isDraggingVideoSlider = false;
  EnMedia? _media;

  @override
  UIStateNullable<PlayerState> build() {
    final PlayerVideoState? videoState = ref.watch(playerVideoProvider).value;
    if (videoState == null) return const UIStateNullable(isLoading: true);
    final EnMedia? playingMedia = ref.watch(playingMediaProvider).value;
    _media = playingMedia;
    if (playingMedia == null) return const UIStateNullable(isLoading: true);
    final sentenceList = playingMedia.subtitleList.firstOrNull?.sentenceList;
    final playingSentenceId = (sentenceList == null || sentenceList.isEmpty)
        ? null
        : sentenceList.first.id;

    return UIStateNullable(
      isLoading: false,
      data: PlayerState(
        title: playingMedia.name,
        sentenceCount: sentenceList?.length ?? 0,
        videoState: videoState,
        scrollController: ItemScrollController(),
        playingSentenceId: playingSentenceId,
      ),
    );
  }

  void _updateVideoState(PlayerVideoState videoState) {
    state = state.copyWith(
      data: () => state.data?.copyWith(videoState: videoState),
    );
  }

  void tapSentence(int? sentenceId) async {
    final videoController = _videoController;
    if (videoController == null) return;
    final videoState = _videoState;
    if (videoState == null) return;
    final sentenceList = _media?.subtitleList.firstOrNull?.sentenceList;
    final sentenceIndex = sentenceList?.firstIndexWhereOrNull(
      (sen) => sen.id == sentenceId,
    );
    if (sentenceIndex == null) return;
    final sentence = sentenceList?[sentenceIndex];
    if (sentence == null) return;

    _scrollController?._scrollTo(sentenceIndex);
    if (videoState.isLoop) {
      _updateVideoState(videoState.copyWith(loopIndex: () => sentenceIndex));
    }
    await videoController.seekTo(sentence.start);
    await videoController.play();
  }

  int? sentenceIdAtIndex(int i) {
    return _media?.subtitleList.firstOrNull?.sentenceList
        .elementAtOrNull(i)
        ?.id;
  }

  void scrollToTop() {
    _scrollController?._scrollTo(0);
  }

  void scrollToPlayingSentence() {
    final sentenceList = _media?.subtitleList.firstOrNull?.sentenceList;
    if (sentenceList == null || sentenceList.isEmpty) return;
    final positionMicro = _videoState?.positionMicro;
    if (positionMicro == null) return;
    Duration position = Duration(microseconds: positionMicro);
    final playingSentenceIndex = _sentenceIndexByPosition(position);
    if (playingSentenceIndex == null) return;
    _scrollController?._scrollTo(playingSentenceIndex);
  }

  void scrollToBottom() {
    final sentenceList = _media?.subtitleList.firstOrNull?.sentenceList;
    if (sentenceList == null || sentenceList.isEmpty) return;
    _scrollController?._scrollTo(sentenceList.length - 1);
  }

  Future<void> decSpeed() async {
    final videoState = _videoState;
    if (videoState == null) return;
    final currSpeed = videoState.speed;
    final double nextSpeed = (currSpeed - _kStepPlaySpeed).clamp(
      _kMinPlaySpeed,
      _kMaxPlaySpeed,
    );
    _updateVideoState(videoState.copyWith(speed: nextSpeed));
    await _videoController?.setPlaybackSpeed(nextSpeed);
  }

  Future<void> incSpeed() async {
    final videoState = _videoState;
    if (videoState == null) return;
    final currSpeed = videoState.speed;
    final double nextSpeed = (currSpeed + _kStepPlaySpeed).clamp(
      _kMinPlaySpeed,
      _kMaxPlaySpeed,
    );
    _updateVideoState(videoState.copyWith(speed: nextSpeed));
    await _videoController?.setPlaybackSpeed(nextSpeed);
  }

  Future<void> resetSpeed() async {
    final videoState = _videoState;
    if (videoState == null) return;
    final nextSpeed = (1.0).clamp(_kMinPlaySpeed, _kMaxPlaySpeed);
    _updateVideoState(videoState.copyWith(speed: nextSpeed));
    await _videoController?.setPlaybackSpeed(nextSpeed);
  }

  Future<void> play() async {
    final videoState = _videoState;
    if (videoState == null) return;
    _updateVideoState(videoState.copyWith(isPlaying: true));
    await _videoController?.play();
  }

  Future<void> pause() async {
    final videoState = _videoState;
    if (videoState == null) return;
    _updateVideoState(videoState.copyWith(isPlaying: false));
    await _videoController?.pause();
  }

  void toggleLoop() {
    final videoState = _videoState;
    if (videoState == null) return;
    final isLoop = videoState.isLoop;
    if (isLoop) {
      //unloop
      _updateVideoState(videoState.copyWith(loopIndex: () => null));
    } else {
      //loop
      final position = videoState.positionMicro;
      final playingSentenceIndex = _sentenceIndexByPosition(
        Duration(microseconds: position),
      );
      _updateVideoState(
        videoState.copyWith(loopIndex: () => playingSentenceIndex),
      );
    }
  }

  Future<void> videoPositionChanged(
    VideoPlayerController videoController,
  ) async {
    final data = state.data;
    final videoState = _videoState;
    if (data == null || videoState == null) return;
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
    if (data.sentenceCount == 0) return;
    final sentenceList = _media?.subtitleList.firstOrNull?.sentenceList;
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
    if (!videoState.isLoop && isSentenceChanged) {
      debugPrint(
        'positon changing scrollto ${playingSentence ?? sentenceList.last}',
      );
      _scrollController?._scrollTo(
        playingSentenceIndex ?? sentenceList.length - 1,
      );
    }
    //handle loop seek to begin
    final loopingIndex = videoState.loopIndex;
    if (videoState.isLoop && loopingIndex != null) {
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
    final sentenceList = _media?.subtitleList.firstOrNull?.sentenceList;
    if (sentenceList == null || sentenceList.isEmpty) return;
    final PlayerState? newData;
    if (index == null) {
      newData = state.data?.copyWith(playingSentenceId: () => null);
    } else {
      int? id = sentenceList.elementAtOrNull(index)?.id;
      newData = state.data?.copyWith(playingSentenceId: () => id);
    }
    state = state.copyWith(data: () => newData);
  }

  int? _sentenceIndexByPosition(Duration position) {
    final duration = _videoController?.value.duration;
    if (duration == null) return null;
    final sentenceList = _media?.subtitleList.firstOrNull?.sentenceList;
    if (sentenceList == null || sentenceList.isEmpty) return null;
    for (int i = 0; i < sentenceList.length; i++) {
      EnSentence? prev = i == 0 ? null : sentenceList[i - 1];
      EnSentence? next = sentenceList.elementAtOrNull(i + 1);
      EnSentence sentence = sentenceList[i];
      if (sentence.isPlaying(prev, next, position, duration)) {
        return i;
      }
    }
    return null;
  }

  Future<void> _syncVideoWithSlider(Duration position) async {
    final videoState = _videoState;
    if (videoState == null) return;
    final sentenceList = _media?.subtitleList.firstOrNull?.sentenceList;
    if (sentenceList == null || sentenceList.isEmpty) return;
    final playingSentenceIndex = _sentenceIndexByPosition(position);
    if (_videoState?.isLoop == true) {
      debugPrint(
        'sliding loop ${_media?.subtitleList.firstOrNull?.sentenceList.elementAtOrNull(playingSentenceIndex ?? 9999)}',
      );
      _updateVideoState(
        videoState.copyWith(loopIndex: () => playingSentenceIndex),
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
      videoState.copyWith(positionMicro: position.inMicroseconds),
    );
    await _videoController?.seekTo(position);
  }

  Future<void> videoSliderStartChanged(double valMicro) async {
    final videoState = _videoState;
    if (videoState == null) return;

    _isDraggingVideoSlider = true;
    debugPrint('start of slide: pause');
    _updateVideoState(videoState.copyWith(isPlaying: false));
    await _videoController?.pause();

    await _syncVideoWithSlider(Duration(microseconds: valMicro.toInt()));
  }

  Future<void> videoSliderChanging(double valMicro) async {
    // debugPrint('videoSliderChanging $valMicro');
    await _syncVideoWithSlider(Duration(microseconds: valMicro.toInt()));
  }

  Future<void> videoSliderEndChanged(double valMicro) async {
    final videoState = _videoState;
    final videoController = _videoController;
    final sentenceList = _media?.subtitleList.firstOrNull?.sentenceList;
    if (videoController == null ||
        sentenceList == null ||
        sentenceList.isEmpty ||
        videoState == null) {
      _isDraggingVideoSlider = false;
      return;
    }
    final duration = videoController.value.duration;
    final position = Duration(microseconds: valMicro.toInt());
    //seek to sentence start
    final Duration seekTo;
    final playingSentenceIndex = _sentenceIndexByPosition(position);
    if (_videoState?.isLoop == true) {
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
      _updateVideoState(videoState.copyWith(isPlaying: true));
      await _videoController?.play();
    }
    debugPrint('end of slide: isdragging false');
    _isDraggingVideoSlider = false;
  }

  Future<void> updateVolume(double newVolume) async {
    final videoState = _videoState;
    if (videoState == null) return;
    _updateVideoState(videoState.copyWith(volume: newVolume));
    await _videoController?.setVolume(newVolume);
  }

  void toggleVolume() {
    final videoState = _videoState;
    if (videoState == null) return;
    final visible = _videoState?.showVolumeSlider;
    if (visible == null) return;
    _updateVideoState(videoState.copyWith(showVolumeSlider: !visible));
  }

  Future<void> addSubtitle() async {
    final media = _media;
    if (media == null) return;
    final subtitlePath = await _pickOneSubtitle();
    if (subtitlePath == null) return;

    final subtitle = await SubtitleParser.parsePath(subtitlePath);
    if (subtitle != null) {
      await ref
          .read(dbAlbumListProvider.notifier)
          .updateMedia(media, subtitle: () => subtitle);
    }
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
  Future<PlayerVideoState?> build() async {
    final VideoPlayerController? videoController = ref
        .watch(playerVideoControllerProvider)
        .value;
    if (videoController == null) return null;
    final EnMedia? media = ref.watch(playingMediaProvider).value;
    //because of this is read and have to await, this has to be a AsyncNotifier
    final loop = await ref.read(
      dbPrefProvider.selectAsync((pref) => pref.loop),
    );
    final int? loopingIndex;
    if (loop) {
      final sentenceList = media?.subtitleList.firstOrNull?.sentenceList;
      loopingIndex = (sentenceList == null || sentenceList.isEmpty) ? null : 0;
    } else {
      loopingIndex = null;
    }
    return PlayerVideoState(
      positionMicro: 0,
      showVolumeSlider: false,
      controller: videoController,
      isPlaying: true,
      speed: 1,
      volume: 1,
      loopIndex: loopingIndex,
    );
  }
}

@riverpod
class PlayerVideoController extends _$PlayerVideoController {
  @override
  Future<VideoPlayerController?> build() async {
    final String? path = ref.watch(
      playingMediaProvider.select((st) => st.value?.path),
    );
    if (path == null || path.isEmpty) return null;
    final videoController = VideoPlayerController.file(File(path));
    ref.onDispose(() {
      videoController.dispose();
    });
    //its neccessary to await initialize, otherwise aspectratio etc will wrong
    await videoController.initialize();
    await videoController.play();
    return videoController;
  }
}

const double _kMaxPlaySpeed = 3.0;
const double _kMinPlaySpeed = 0.25;
const double _kStepPlaySpeed = 0.25;

extension on EnSentence {
  bool isPlaying(
    EnSentence? prev,
    EnSentence? next,
    Duration position,
    Duration duration,
  ) {
    //刚开始的时候position=0,但是第一句话的start不一定是0
    //所以当position=0的时候，就不处于任何一句话的区间，这里直接做个判断就省了后面的几百句话的遍历
    final start = prev == null ? const Duration(microseconds: 0) : this.start;
    if (next == null) {
      return start <= position && position <= duration;
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
