import 'package:collection/collection.dart';
import 'package:defer/defer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockingbird/db/entities/en_media.dart';
import 'package:mockingbird/db/entities/en_sentence.dart';
import 'package:mockingbird/db/providers/db_album_list_provider.dart';
import 'package:mockingbird/db/providers/db_playing_media_provider.dart';
import 'package:mockingbird/tab_player/player/providers/player_setting_provider.dart';
import 'package:mockingbird/tab_player/player/providers/player_subtitle_provider.dart';
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
    ref.read(playerVideoProvider.notifier).updatePosition(position);

    final duration = videoController.value.duration;
    if (position >= duration) {
      //if video end of duration, play/pause button should update
      await ref.read(playerVideoProvider.notifier).pause();
    }
    //prevent videoController.play() but _state not setuped fully.
    final isLoop = ref.read(playerSettingProvider.select((st)=>st.value?.isLoop ?? false));
    if (_isDraggingVideoSlider) {
      ref.read(playerSubtitleProvider.notifier).jumpToPlayingSentence();
    } else if (!isLoop) {
      //playing auto scroll to next sentence, not for loop mode
      ref.read(playerSubtitleProvider.notifier).scrollToPlayingSentence();
    }
    //handle loop seek to begin
    final loopSentence = ref.read(playerSubtitleProvider.notifier).loopSentence;
    if (!_isDraggingVideoSlider && loopSentence != null) {
      //if repeat one is turn on, while sentence finished, seek to beginning
      // debugPrint('position changing loop $sentence');
      if (position > loopSentence.end) {
        // debugPrint('positon changing loop seek to ${sentence.start}');
        await videoController.seekTo(loopSentence.start);
      }
    }
  }

  Future<void> videoSliderStartChanged(double valMicro) async {
    _isDraggingVideoSlider = true;
    debugPrint('slider: start');
    await ref.read(playerVideoProvider.notifier).pause();
    final position = Duration(microseconds: valMicro.toInt());
    await ref.read(playerVideoProvider.notifier).seekTo(position);
  }

  Future<void> videoSliderChanging(double valMicro) async {
    final position = Duration(microseconds: valMicro.toInt());
    await ref.read(playerVideoProvider.notifier).seekTo(position);
  }

  Future<void> videoSliderEndChanged(double valMicro) async {
    await defer(
      () async {
        _isDraggingVideoSlider = false;
        debugPrint('slider: end');
      },
      () async {
        final position = Duration(microseconds: valMicro.toInt());
        //seek to sentence start
        final loopSentence = ref.read(playerSubtitleProvider.notifier).loopSentence;
        final Duration seekTo = loopSentence == null ? position : loopSentence.start;
        await ref.read(playerVideoProvider.notifier).seekTo(seekTo);

        final duration = ref.read(playerVideoProvider.notifier).duration;
        if (duration != null && seekTo < duration) {
          debugPrint('slider: play');
          await ref.read(playerVideoProvider.notifier).play();
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
