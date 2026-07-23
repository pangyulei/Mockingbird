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
  PlayerData get _data => state.requireValue as PlayerData;
  PlayerVideoData get _videoData => _data.videoData;
  ItemScrollController get _scrollController => _videoData.scrollController;
  VideoPlayerController get _videoController => _videoData.videoController;

  List<EnSentence> get _sentenceList =>
      ref.read(
        dbPlayingMediaProvider.select(
          (st) => st.value?.subtitleList.firstOrNull?.sentenceList,
        ),
      ) ??
      [];

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

  void tapSentence(int? sentenceId) async {
    final sentenceIndex = _sentenceList.firstIndexWhereOrNull(
      (sen) => sen.id == sentenceId,
    )!;
    final sentence = _sentenceList[sentenceIndex];

    _scrollController._scrollTo(sentenceIndex);
    if (_data.videoData.isLoop) {
      state = AsyncData(
        _data.copyWith(
          videoData: _data.videoData.copyWith(loopIndex: () => sentenceIndex),
        ),
      );
    }
    await _videoController.seekTo(sentence.start);
    await _videoController.play();
  }

  void scrollToTop() {
    _scrollController._scrollTo(0);
  }

  void scrollToPlayingSentence() {
    final positionMicro = _videoData.positionMicro;
    Duration position = Duration(microseconds: positionMicro);
    final playingSentenceIndex = _sentenceIndexByPosition(position);
    _scrollController._scrollTo(playingSentenceIndex);
  }

  void scrollToBottom() {
    _scrollController._scrollTo(_sentenceList.length - 1);
  }

  Future<void> decSpeed() async {
    final currSpeed = _videoData.speed;
    final double nextSpeed = (currSpeed - _kStepPlaySpeed).clamp(
      _kMinPlaySpeed,
      _kMaxPlaySpeed,
    );
    state = AsyncData(
      _data.copyWith(videoData: _videoData.copyWith(speed: nextSpeed)),
    );
    await _videoController.setPlaybackSpeed(nextSpeed);
  }

  Future<void> incSpeed() async {
    final currSpeed = _videoData.speed;
    final double nextSpeed = (currSpeed + _kStepPlaySpeed).clamp(
      _kMinPlaySpeed,
      _kMaxPlaySpeed,
    );
    state = AsyncData(
      _data.copyWith(videoData: _videoData.copyWith(speed: nextSpeed)),
    );
    await _videoController.setPlaybackSpeed(nextSpeed);
  }

  Future<void> resetSpeed() async {
    final nextSpeed = (1.0).clamp(_kMinPlaySpeed, _kMaxPlaySpeed);
    state = AsyncData(
      _data.copyWith(videoData: _videoData.copyWith(speed: nextSpeed)),
    );
    await _videoController.setPlaybackSpeed(nextSpeed);
  }

  Future<void> play() async {
    state = AsyncData(
      _data.copyWith(videoData: _videoData.copyWith(isPlaying: true)),
    );
    await _videoController.play();
  }

  Future<void> pause() async {
    state = AsyncData(
      _data.copyWith(videoData: _videoData.copyWith(isPlaying: false)),
    );
    await _videoController.pause();
  }

  void toggleLoop() {
    if (_videoData.isLoop) {
      //unloop
      state = AsyncData(
        _data.copyWith(videoData: _videoData.copyWith(loopIndex: () => null)),
      );
    } else {
      //loop
      final position = _videoData.positionMicro;
      final playingSentenceIndex = _sentenceIndexByPosition(
        Duration(microseconds: position),
      );
      state = AsyncData(
        _data.copyWith(
          videoData: _videoData.copyWith(loopIndex: () => playingSentenceIndex),
        ),
      );
    }
  }

  Future<void> videoPositionChanged(
    VideoPlayerController videoController,
  ) async {
    final position = videoController.value.position;
    //for video slider moving along with playing
    state = AsyncData(
      _data.copyWith(
        videoData: _videoData.copyWith(positionMicro: position.inMicroseconds),
      ),
    );
    if (_isDraggingVideoSlider) return;
    final duration = videoController.value.duration;
    if (position >= duration) {
      //if video end of duration, play/pause button should update
      state = AsyncData(
        _data.copyWith(videoData: _videoData.copyWith(isPlaying: false)),
      );
    }
    //prevent videoController.play() but _state not setuped fully.
    if (_sentenceList.isEmpty) return;

    final playingSentenceIndex = _sentenceIndexByPosition(position);
    final playingSentence = _sentenceList.elementAtOrNull(playingSentenceIndex);
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
    if (!_videoData.isLoop && isSentenceChanged) {
      _scrollController._scrollTo(playingSentenceIndex);
    }
    //handle loop seek to begin
    if (_videoData.isLoop) {
      //if repeat one is turn on, while sentence finished, seek to beginning
      final sentence = _sentenceList[_videoData.loopIndex!];
      // debugPrint('position changing loop $sentence');
      if (position > sentence.end) {
        // debugPrint('positon changing loop seek to ${sentence.start}');
        await videoController.seekTo(sentence.start);
      }
    }
    _prevPlayingSentenceIndex = playingSentenceIndex;
  }

  void _markSentence(int? index) {
    final data = state.value;
    if (data is! PlayerData) return;
    final sentenceList = _sentenceList;
    if (sentenceList.isEmpty) return;
    if (index == null) {
      state = AsyncData(
        data.copyWith(
          videoData: data.videoData.copyWith(playingSentenceId: () => null),
        ),
      );
    } else {
      int? id = sentenceList.elementAtOrNull(index)?.id;
      state = AsyncData(
        data.copyWith(
          videoData: data.videoData.copyWith(playingSentenceId: () => id),
        ),
      );
    }
  }

  int _sentenceIndexByPosition(Duration position) {
    final duration = _videoData.videoController.value.duration;
    for (int i = 0; i < _sentenceList.length; i++) {
      EnSentence? prev = i == 0 ? null : _sentenceList[i - 1];
      EnSentence? next = _sentenceList.elementAtOrNull(i + 1);
      EnSentence sentence = _sentenceList[i];
      if (sentence.isPlaying(prev, next, position, duration)) {
        return i;
      }
    }
    throw ErrorDescription(
      '如果你有sentencelist你肯定会定位到其中一句字幕，如果你没有字幕，你根本不应该会用到这个方法',
    );
  }

  Future<void> _syncVideoWithSlider(Duration position) async {
    // state = AsyncData(
    //   _data.copyWith(
    //     videoData: _videoData.copyWith(positionMicro: position.inMicroseconds),
    //   ),
    // );
    await _videoController.seekTo(position);

    if (_sentenceList.isEmpty) return;
    final playingSentenceIndex = _sentenceIndexByPosition(position);
    if (_videoData.isLoop) {
      state = AsyncData(
        _data.copyWith(
          videoData: _videoData.copyWith(loopIndex: () => playingSentenceIndex),
        ),
      );
    }
    _markSentence(playingSentenceIndex);
    _scrollController._jumpTo(playingSentenceIndex);
  }

  Future<void> videoSliderStartChanged(double valMicro) async {
    _isDraggingVideoSlider = true;
    debugPrint('slider start');
    state = AsyncData(
      _data.copyWith(videoData: _videoData.copyWith(isPlaying: false)),
    );
    await _videoController.pause();
    await _syncVideoWithSlider(Duration(microseconds: valMicro.toInt()));
  }

  Future<void> videoSliderChanging(double valMicro) async {
    await _syncVideoWithSlider(Duration(microseconds: valMicro.toInt()));
  }

  Future<void> videoSliderEndChanged(double valMicro) async {
    await defer(
      () async {
        _isDraggingVideoSlider = false;
        debugPrint('slider end');
      },
      () async {
        if (_sentenceList.isEmpty) {
          // _isDraggingVideoSlider = false;
          return;
        }
        final duration = _videoController.value.duration;
        final position = Duration(microseconds: valMicro.toInt());
        //seek to sentence start
        final Duration seekTo;
        final playingSentenceIndex = _sentenceIndexByPosition(position);
        if (_videoData.isLoop == true) {
          final playingSentence = _sentenceList[playingSentenceIndex];
          seekTo = playingSentence.start;
        } else {
          seekTo = position;
        }

        await _syncVideoWithSlider(seekTo);
        if (seekTo < duration) {
          debugPrint('slider: play');
          state = AsyncData(
            _data.copyWith(videoData: _videoData.copyWith(isPlaying: true)),
          );
          await _videoController.play();
        }
      },
    );
  }

  Future<void> updateVolume(double newVolume) async {
    state = AsyncData(
      _data.copyWith(videoData: _videoData.copyWith(volume: newVolume)),
    );
    await _videoController.setVolume(newVolume);
  }

  void toggleVolume() {
    final visible = _videoData.showVolumeSlider;
    state = AsyncData(
      _data.copyWith(
        videoData: _videoData.copyWith(showVolumeSlider: !visible),
      ),
    );
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
  final _scrollController = ItemScrollController();
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
    _scrollController._jumpTo(0);
    return PlayerVideoData(
      sentenceIdList: sentenceList?.map((sen) => sen.id).toList() ?? [],
      scrollController: _scrollController,
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
  void _jumpTo(int index, {double alignment = 0}) {
    if (isAttached) {
      jumpTo(index: index, alignment: alignment);
    } else {
      debugPrint('${identityHashCode(this)} jump fail, scroll is not attached');
    }
  }

  void _scrollTo(
    int index, {
    double alignment = 0,
    Duration duration = const Duration(milliseconds: 250),
  }) {
    if (isAttached) {
      scrollTo(index: index, duration: duration, alignment: alignment);
    } else {
      debugPrint(
        '${identityHashCode(this)} scroll fail, scroll is not attached',
      );
    }
  }
}
