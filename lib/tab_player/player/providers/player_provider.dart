import 'package:collection/collection.dart';
import 'package:defer/defer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockingbird/db/entities/en_sentence.dart';
import 'package:mockingbird/db/providers/db_playing_media_provider.dart';
import 'package:mockingbird/tab_player/player/providers/player_media_provider.dart';
import 'package:mockingbird/tab_player/player/providers/player_setting_provider.dart';
import 'package:mockingbird/tab_player/player/providers/player_spot_provider.dart';
import 'package:mockingbird/tab_player/player/providers/player_video_controller_provider.dart';
import 'package:mockingbird/tab_player/player/states/player_media_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../../db/entities/en_media.dart';
import '../../../db/providers/db_media_provider.dart';
import '../../../tool/extensions.dart';
import '../../../tool/subtitle_parser.dart';

part 'player_provider.g.dart';

@riverpod
class Player extends _$Player {
  bool _isDraggingVideoSlider = false;
  int? _prevPlayingSentenceIndex;
  List<EnSentence> get _sentenceList => ref.read(
    dbPlayingMediaProvider.select(
      (st) => st.value?.subtitleList.firstOrNull?.sentenceList ?? [],
    ),
  );

  @override
  void build(ItemScrollController scrollController) {
    _listen();
  }

  void _videoPositionChanged(Duration position) async {
    //handle loop seek to begin
    final loopSentence = ref.read(playerSpotProvider.notifier).loopSentence;
    if (!_isDraggingVideoSlider && loopSentence != null) {
      //if repeat one is turn on, while sentence finished, seek to beginning
      // debugPrint('position changing loop $sentence');
      if (position > loopSentence.end) {
        // debugPrint('positon changing loop seek to ${sentence.start}');
        ref.read(playerMediaProvider.notifier).seekTo(loopSentence.start);
      }
    }
  }

  void _listen() {
    ref.listen(playerSpotProvider.select((st) => st.value), (previous, spot) {
      final bool isSentenceChanged =
          spot?.playingSentenceIndex != _prevPlayingSentenceIndex;
      final isLoop = ref.read(
        playerSettingProvider.select((st) => st.value?.isLoop ?? false),
      );
      //handle scroll
      if (isSentenceChanged) {
        if (_isDraggingVideoSlider) {
          scrollController.safeJumpTo(
            spot?.playingSentenceIndex,
            alignment: 0.3,
          );
        } else if (!isLoop) {
          //playing auto scroll to next sentence, not for loop mode
          scrollController.safeScrollTo(
            spot?.playingSentenceIndex,
            alignment: 0.3,
          );
        }
      }
      _prevPlayingSentenceIndex = spot?.playingSentenceIndex;
    });
    ref.listen(
      playerMediaProvider
          .select(
            (st) => st.value is PlayerMediaData
                ? (st.value as PlayerMediaData)
                : null,
          )
          .select((data) => data?.positionMicro),
      (previous, positionMicro) {
        if (positionMicro == null) return;
        _videoPositionChanged(Duration(microseconds: positionMicro));
      },
    );
    ref.listen(playerVideoControllerProvider, (previous, next) {
      //video changed
      scrollToTop();
    });
  }

  Future<void> videoSliderStartChanged(double valMicro) async {
    _isDraggingVideoSlider = true;
    debugPrint('slider: start');
    await ref.read(playerMediaProvider.notifier).pause();
    final position = Duration(microseconds: valMicro.toInt());
    await ref.read(playerMediaProvider.notifier).seekTo(position);
  }

  Future<void> videoSliderChanging(double valMicro) async {
    final position = Duration(microseconds: valMicro.toInt());
    await ref.read(playerMediaProvider.notifier).seekTo(position);
  }

  Future<void> videoSliderEndChanged(double valMicro) async {
    await defer(
      () async {
        _isDraggingVideoSlider = false;
        debugPrint('slider: end');
      },
      () async {
        final position = Duration(microseconds: valMicro.toInt());
        // seek to sentence start
        final loopSentence = ref.read(playerSpotProvider.notifier).loopSentence;
        final Duration seekToPosition = loopSentence == null
            ? position
            : loopSentence.start;
        await ref.read(playerMediaProvider.notifier).seekTo(seekToPosition);

        final duration = ref.read(playerMediaProvider.notifier).duration;
        debugPrint('duration $duration seekto $seekToPosition');
        if (duration != null && seekToPosition < duration) {
          debugPrint('slider: play');
          await ref.read(playerMediaProvider.notifier).play();
        }
      },
    );
  }

  void scrollToTop() {
    scrollController.safeScrollTo(0);
  }

  void scrollToBottom() {
    scrollController.safeScrollTo(_sentenceList.length - 1);
  }

  void scrollToPlayingSentence() {
    final index = ref.read(
      playerSpotProvider.select((st) => st.value?.playingSentenceIndex),
    );
    scrollController.safeScrollTo(index, alignment: 0.3);
  }

  void tapSentence(int? id) async {
    if (id == null) return;
    final sentenceIndex = _sentenceList.firstIndexWhereOrNull(
      (sen) => sen.id == id,
    );
    if (sentenceIndex == null) return;
    final sentence = _sentenceList[sentenceIndex];
    debugPrint('tap id($id) index($sentenceIndex): ${sentence.text}');
    scrollController.safeScrollTo(sentenceIndex, alignment: 0.3);
    await ref.read(playerMediaProvider.notifier).seekTo(sentence.start);
    await ref.read(playerMediaProvider.notifier).play();
  }

  Future<void> addSubtitle() async {
    final media = ref.read(dbPlayingMediaProvider).value;
    final subtitlePath = await _pickOneSubtitle();
    if (subtitlePath == null) return;

    final subtitle = await SubtitleParser.parsePath(subtitlePath);
    if (subtitle != null) {
      await ref
          .read(dbMediaProvider(media?.id).notifier)
          .edit(subtitle: () => subtitle);
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

extension on EnSentence {
  bool isPlaying(EnSentence? prev, EnSentence? next, Duration position) {
    final start = prev == null ? const Duration(microseconds: 0) : this.start;
    if (next == null) {
      return start <= position;
    } else {
      return start <= position && position < next.start;
    }
  }
}
