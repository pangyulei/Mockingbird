import 'dart:io';

import 'package:collection/collection.dart';
import 'package:defer/defer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockingbird/db/entities/en_media.dart';
import 'package:mockingbird/db/entities/en_sentence.dart';
import 'package:mockingbird/db/entities/en_subtitle.dart';
import 'package:mockingbird/db/providers/db_album_list_provider.dart';
import 'package:mockingbird/db/providers/db_playing_media_provider.dart';
import 'package:mockingbird/db/providers/db_pref_provider.dart';
import 'package:mockingbird/tab_player/player/player_state.dart';
import 'package:mockingbird/tool/extensions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:video_player/video_player.dart';

import '../../tool/subtitle_parser.dart';

part 'player_provider.g.dart';

@riverpod
class Player extends _$Player {
  int? _prevPlayingSentenceIndex;
  bool _isDraggingVideoSlider = false;

  @override
  Future<PlayerState> build() async {
    final PlayerVideoData? videoData = await ref.watch(
      playerVideoDataProvider.future,
    );
    if (videoData == null) {
      return const PlayerNull();
    }
    final String mediaName =
        await ref.watch(dbPlayingMediaProvider.selectAsync((st) => st?.name)) ??
        '';
    return PlayerData(title: mediaName, videoData: videoData);
  }

  void _updateVideoData(PlayerVideoData videoData) {
    final data = state.value;
    if (data is! PlayerData) return;
    state = AsyncData(data.copyWith(videoData: videoData));
  }

  List<EnSentence>? get _sentenceList => ref.read(
    dbPlayingMediaProvider.select(
      (st) => st.value?.subtitleList.firstOrNull?.sentenceList,
    ),
  );

  void tapSentence(int? sentenceId) async {
    final data = state.value;
    if (data is! PlayerData) return;
    final sentenceIndex = _sentenceList?.firstIndexWhereOrNull(
      (sen) => sen.id == sentenceId,
    );
    if (sentenceIndex == null) return;
    final sentence = _sentenceList?[sentenceIndex];
    if (sentence == null) return;

    data.videoData.scrollController._scrollTo(sentenceIndex);
    if (data.videoData.isLoop) {
      _updateVideoData(
        data.videoData.copyWith(getLoopIndex: () => sentenceIndex),
      );
    }
    await data.videoData.videoController.seekTo(sentence.start);
    await data.videoData.videoController.play();
  }

  void scrollToTop() {
    final data = state.value;
    if (data is! PlayerData) return;
    data.videoData.scrollController._scrollTo(0);
  }

  void scrollToPlayingSentence() {
    final data = state.value;
    if (data is! PlayerData) return;
    final sentenceList = _sentenceList;
    if (sentenceList == null || sentenceList.isEmpty) return;
    final positionMicro = data.videoData.positionMicro;
    Duration position = Duration(microseconds: positionMicro);
    final playingSentenceIndex = _sentenceIndexByPosition(position);
    if (playingSentenceIndex == null) return;
    data.videoData.scrollController._scrollTo(playingSentenceIndex);
  }

  void scrollToBottom() {
    final data = state.value;
    if (data is! PlayerData) return;
    final sentenceList = _sentenceList;
    if (sentenceList == null || sentenceList.isEmpty) return;
    data.videoData.scrollController._scrollTo(sentenceList.length - 1);
  }

  Future<void> decSpeed() async {
    final data = state.value;
    if (data is! PlayerData) return;
    final currSpeed = data.videoData.speed;
    final double nextSpeed = (currSpeed - _kStepPlaySpeed).clamp(
      _kMinPlaySpeed,
      _kMaxPlaySpeed,
    );
    _updateVideoData(data.videoData.copyWith(speed: nextSpeed));
    await data.videoData.videoController.setPlaybackSpeed(nextSpeed);
  }

  Future<void> incSpeed() async {
    final data = state.value;
    if (data is! PlayerData) return;
    final currSpeed = data.videoData.speed;
    final double nextSpeed = (currSpeed + _kStepPlaySpeed).clamp(
      _kMinPlaySpeed,
      _kMaxPlaySpeed,
    );
    _updateVideoData(data.videoData.copyWith(speed: nextSpeed));
    await data.videoData.videoController.setPlaybackSpeed(nextSpeed);
  }

  Future<void> resetSpeed() async {
    final data = state.value;
    if (data is! PlayerData) return;
    final nextSpeed = (1.0).clamp(_kMinPlaySpeed, _kMaxPlaySpeed);
    _updateVideoData(data.videoData.copyWith(speed: nextSpeed));
    await data.videoData.videoController.setPlaybackSpeed(nextSpeed);
  }

  Future<void> play() async {
    final data = state.value;
    if (data is! PlayerData) return;
    _updateVideoData(data.videoData.copyWith(isPlaying: true));
    await data.videoData.videoController.play();
  }

  Future<void> pause() async {
    final data = state.value;
    if (data is! PlayerData) return;
    _updateVideoData(data.videoData.copyWith(isPlaying: false));
    await data.videoData.videoController.pause();
  }

  void toggleLoop() {
    final data = state.value;
    if (data is! PlayerData) return;
    final isLoop = data.videoData.isLoop;
    if (isLoop) {
      //unloop
      _updateVideoData(data.videoData.copyWith(getLoopIndex: () => null));
    } else {
      //loop
      final position = data.videoData.positionMicro;
      final playingSentenceIndex = _sentenceIndexByPosition(
        Duration(microseconds: position),
      );
      _updateVideoData(
        data.videoData.copyWith(getLoopIndex: () => playingSentenceIndex),
      );
    }
  }

  Future<void> videoPositionChanged(
    VideoPlayerController videoController,
  ) async {
    final data = state.value;
    if (data is! PlayerData) return;
    if (_isDraggingVideoSlider) return;
    final position = videoController.value.position;
    //for video slider moving along with playing
    _updateVideoData(
      data.videoData.copyWith(positionMicro: position.inMicroseconds),
    );
    final duration = videoController.value.duration;
    if (position >= duration) {
      //if video end of duration, play/pause button should update
      _updateVideoData(data.videoData.copyWith(isPlaying: false));
    }
    //prevent videoController.play() but _state not setuped fully.
    if (data.videoData.sentenceIdList.isEmpty) return;
    final sentenceList = _sentenceList;
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
    if (!data.videoData.isLoop && isSentenceChanged) {
      debugPrint(
        'positon changing scrollto ${playingSentence ?? sentenceList.last}',
      );
      data.videoData.scrollController._scrollTo(
        playingSentenceIndex ?? sentenceList.length - 1,
      );
    }
    //handle loop seek to begin
    final loopingIndex = data.videoData.loopIndex;
    if (data.videoData.isLoop && loopingIndex != null) {
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
    final data = state.value;
    if (data is! PlayerData) return;
    final sentenceList = _sentenceList;
    if (sentenceList == null || sentenceList.isEmpty) return;
    if (index == null) {
      state = AsyncData(
        data.copyWith(
          videoData: data.videoData.copyWith(getPlayingSentenceId: () => null),
        ),
      );
    } else {
      int? id = sentenceList.elementAtOrNull(index)?.id;
      state = AsyncData(
        data.copyWith(
          videoData: data.videoData.copyWith(getPlayingSentenceId: () => id),
        ),
      );
    }
  }

  int? _sentenceIndexByPosition(Duration position) {
    final data = state.value;
    if (data is! PlayerData) return null;
    final duration = data.videoData.videoController.value.duration;
    final sentenceList = _sentenceList;
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
    final data = state.value;
    if (data is! PlayerData) return;
    final sentenceList = _sentenceList;
    if (sentenceList == null || sentenceList.isEmpty) return;
    final playingSentenceIndex = _sentenceIndexByPosition(position);
    if (data.videoData.isLoop == true) {
      _updateVideoData(
        data.videoData.copyWith(getLoopIndex: () => playingSentenceIndex),
      );
    }
    final playingSentence = playingSentenceIndex == null
        ? null
        : sentenceList.elementAtOrNull(playingSentenceIndex);
    debugPrint('sliding jumpto ${playingSentence ?? sentenceList.last}');
    _markSentence(playingSentenceIndex);
    if (playingSentenceIndex == null) {
      data.videoData.scrollController._scrollTo(sentenceList.length - 1);
    } else {
      data.videoData.scrollController._jumpTo(playingSentenceIndex);
    }
    _updateVideoData(
      data.videoData.copyWith(positionMicro: position.inMicroseconds),
    );
    await data.videoData.videoController.seekTo(position);
  }

  Future<void> videoSliderStartChanged(double valMicro) async {
    final data = state.value;
    if (data is! PlayerData) return;
    _isDraggingVideoSlider = true;
    debugPrint('start of slide: pause');
    _updateVideoData(data.videoData.copyWith(isPlaying: false));
    await data.videoData.videoController.pause();

    await _syncVideoWithSlider(Duration(microseconds: valMicro.toInt()));
  }

  Future<void> videoSliderChanging(double valMicro) async {
    // debugPrint('videoSliderChanging $valMicro');
    await _syncVideoWithSlider(Duration(microseconds: valMicro.toInt()));
  }

  Future<void> videoSliderEndChanged(double valMicro) async {
    await defer(
      () async {
        _isDraggingVideoSlider = false;
        debugPrint('end of slide: isdragging false');
      },
      () async {
        final data = state.value;
        if (data is! PlayerData) return;
        final sentenceList = _sentenceList;
        if (sentenceList == null || sentenceList.isEmpty) {
          // _isDraggingVideoSlider = false;
          return;
        }
        final duration = data.videoData.videoController.value.duration;
        final position = Duration(microseconds: valMicro.toInt());
        //seek to sentence start
        final Duration seekTo;
        final playingSentenceIndex = _sentenceIndexByPosition(position);
        if (data.videoData.isLoop == true) {
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
          _updateVideoData(data.videoData.copyWith(isPlaying: true));
          await data.videoData.videoController.play();
        }
      },
    );
  }

  Future<void> updateVolume(double newVolume) async {
    final data = state.value;
    if (data is! PlayerData) return;
    _updateVideoData(data.videoData.copyWith(volume: newVolume));
    await data.videoData.videoController.setVolume(newVolume);
  }

  void toggleVolume() {
    final data = state.value;
    if (data is! PlayerData) return;
    final visible = data.videoData.showVolumeSlider;
    _updateVideoData(data.videoData.copyWith(showVolumeSlider: !visible));
  }

  Future<void> addSubtitle() async {
    final media = ref.read(dbPlayingMediaProvider).value;
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

//seperate with videocontroller provider, so if you update media's name or its subtitle,
//the videocontroller wont rebuild
final playerVideoDataProvider = AsyncNotifierProvider.autoDispose(
  PlayerVideoDataNotifier.new,
);

class PlayerVideoDataNotifier extends AsyncNotifier<PlayerVideoData?> {
  @override
  Future<PlayerVideoData?> build() async {
    //because of this is read and have to await, this has to be a AsyncNotifier
    final VideoPlayerController? videoController = await ref.watch(
      playerVideoControllerProvider.future,
    );
    if (videoController == null) return null;
    final EnSubtitle? subtitle = await ref.watch(
      dbPlayingMediaProvider.selectAsync((st) => st?.subtitleList.firstOrNull),
    );
    final isLoop = await ref.read(
      dbPrefProvider.selectAsync((pref) => pref.isLoop),
    );
    final int? loopingIndex;
    final sentenceList = subtitle?.sentenceList;
    if (isLoop) {
      //maybe no subtitle, try to set first sentence as loopIndex
      loopingIndex = (sentenceList == null || sentenceList.isEmpty) ? null : 0;
    } else {
      loopingIndex = null;
    }
    final playingSentenceId = (sentenceList == null || sentenceList.isEmpty)
        ? null
        : sentenceList.first.id;
    return PlayerVideoData(
      sentenceIdList: sentenceList?.map((sen)=>sen.id).toList() ?? [],
      scrollController: ItemScrollController(),
      playingSentenceId: playingSentenceId,
      positionMicro: 0,
      showVolumeSlider: false,
      videoController: videoController,
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
    // final String? path = (await ref.watch(dbPlayingMediaProvider.future))?.path;
    final String? path = await ref.watch(
      dbPlayingMediaProvider.selectAsync((st) => st?.path),
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
