import 'package:collection/collection.dart';
import 'package:defer/defer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockingbird/db/entities/en_media.dart';
import 'package:mockingbird/db/entities/en_sentence.dart';
import 'package:mockingbird/db/providers/db_album_list_provider.dart';
import 'package:mockingbird/db/providers/db_playing_media_provider.dart';
import 'package:mockingbird/tab_player/player/providers/player_video_provider.dart';
import 'package:mockingbird/tool/extensions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:video_player/video_player.dart';

import '../../../tool/subtitle_parser.dart';
import '../states/player_state.dart';
import '../states/player_video.dart';


final playerProvider = AsyncNotifierProvider.autoDispose(PlayerNotifier.new);
class PlayerNotifier extends AsyncNotifier<PlayerState> {
  int? _prevPlayingSentenceIndex;
  bool _isDraggingVideoSlider = false;

  @override
  Future<PlayerState> build() async {
    final PlayerVideo? videoData = await ref.watch(playerVideoProvider.future);
    if (videoData == null) {
      return const PlayerNull();
    }
    final String mediaName =
        await ref.watch(dbPlayingMediaProvider.selectAsync((st) => st?.name)) ??
        '';
    return PlayerData(title: mediaName);
  }



  Future<void> videoPositionChanged(
    VideoPlayerController videoController,
  ) async {
    final position = videoController.value.position;
    //for video slider moving along with playing
    state = AsyncData(
      _data.copyWith(
        video: _videoData.copyWith(positionMicro: position.inMicroseconds),
      ),
    );
    final duration = videoController.value.duration;
    if (position >= duration && _videoData.isPlaying) {
      //if video end of duration, play/pause button should update
      state = AsyncData(
        _data.copyWith(video: _videoData.copyWith(isPlaying: false)),
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
    if (isSentenceChanged) {
      //handle mark
      _markSentence(playingSentenceIndex);
      //handle scroll
      if (_isDraggingVideoSlider) {
        _scrollController.safeJumpTo(playingSentenceIndex, alignment: 0.3);
      } else if (!_videoData.isLoop) {
        //playing auto scroll to next sentence, not for loop mode
        _scrollController.safeScrollTo(playingSentenceIndex, alignment: 0.3);
      }
    }
    //handle loop seek to begin
    if (!_isDraggingVideoSlider && _videoData.isLoop) {
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

  Future<void> _syncVideoWithSlider(Duration position) async {
    await _videoController.seekTo(position);

    if (_videoData.isLoop) {
      final playingSentenceIndex = _sentenceIndexByPosition(position);
      state = AsyncData(
        _data.copyWith(
          video: _videoData.copyWith(loopIndex: () => playingSentenceIndex),
        ),
      );
    }
  }

  Future<void> videoSliderStartChanged(double valMicro) async {
    _isDraggingVideoSlider = true;
    debugPrint('slider: start');
    state = AsyncData(
      _data.copyWith(video: _videoData.copyWith(isPlaying: false)),
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
        debugPrint('slider: end');
      },
      () async {
        final duration = _videoController.value.duration;
        final position = Duration(microseconds: valMicro.toInt());
        //seek to sentence start
        final Duration seekTo;
        if (_videoData.isLoop) {
          final playingSentenceIndex = _sentenceIndexByPosition(position);
          final playingSentence = _sentenceList[playingSentenceIndex];
          seekTo = playingSentence.start;
        } else {
          seekTo = position;
        }

        await _syncVideoWithSlider(seekTo);
        if (seekTo < duration) {
          debugPrint('slider: play');
          state = AsyncData(
            _data.copyWith(video: _videoData.copyWith(isPlaying: true)),
          );
          await _videoController.play();
        }
      },
    );
  }

  Future<void> updateVolume(double newVolume) async {
    state = AsyncData(
      _data.copyWith(video: _videoData.copyWith(volume: newVolume)),
    );
    await _videoController.setVolume(newVolume);
  }

  void toggleVolume() {
    final visible = _videoData.showVolumeSlider;
    state = AsyncData(
      _data.copyWith(video: _videoData.copyWith(showVolumeSlider: !visible)),
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
