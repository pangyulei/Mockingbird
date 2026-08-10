import 'package:collection/collection.dart';
import 'package:defer/defer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockingbird/db/providers/db_playing_subtitle_provider.dart';
import 'package:mockingbird/tab_player/player/providers/player_loop_provider.dart';
import 'package:mockingbird/tab_player/player/providers/player_media_controller_provider.dart';
import 'package:mockingbird/tab_player/player/providers/player_media_provider.dart';
import 'package:mockingbird/tab_player/player/providers/player_spot_provider.dart';
import 'package:mockingbird/tab_player/player/states/player_media_state.dart';
import 'package:mockingbird/tool/subtitle_parser.dart';
import 'package:path/path.dart' as p;
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../../db/entities/sentence_entity.dart';
import '../../../db/entities/subtitle_entity.dart';
import '../../../tool/extensions.dart';

final playerProvider = NotifierProvider.autoDispose
    .family<PlayerNotifier, void, ItemScrollController>(PlayerNotifier.new);

class PlayerNotifier extends Notifier<void> {
  bool _isDraggingVideoSlider = false;
  bool _isPlayingBeforeDraged = false;
  int? _prevPlayingSentenceIndex;
  SubtitleEntity? _prevSubtitle;

  SubtitleEntity? get _subtitle => ref.read(dbPlayingSubtitleProvider).value;

  List<SentenceEntity> get _sentenceList => _subtitle?.sentenceList ?? [];

  bool get _loop =>
      ref.read(playerLoopProvider.select((st) => st.value?.loop)) == true;
  final ItemScrollController _scrollController;

  PlayerNotifier(this._scrollController);

  @override
  void build() {
    _listenToLoopSentenceEnd();
    _listenToPlayingSentenceChanged();
  }

  void _listenToPlayingSentenceChanged() async {
    ref.listen(playerSpotProvider.select((st) => st.value), (
      previous,
      spot,
    ) async {
      //handle scroll
      await defer(
        () async {
          _prevPlayingSentenceIndex = spot?.playingSentenceIndex;
          _prevSubtitle = _subtitle;
        },
        () async {
          final isSubtitleChanged = _prevSubtitle != _subtitle;
          if (isSubtitleChanged) {
            _scrollController.safeJumpTo(
              spot?.playingSentenceIndex,
              alignment: 0.3,
            );
            ref
                .read(playerLoopProvider.notifier)
                .updateIndexAndSentenceIfLoop(
                  spot?.playingSentenceIndex,
                  spot?.playingSentence,
                );
            return;
          }
          final bool isSentenceChanged =
              spot?.playingSentenceIndex != _prevPlayingSentenceIndex;
          final loop = await ref.read(
            playerLoopProvider.selectAsync((st) => st.loop),
          );
          if (isSentenceChanged) {
            if (_isDraggingVideoSlider) {
              _scrollController.safeJumpTo(
                spot?.playingSentenceIndex,
                alignment: 0.3,
              );
            } else if (!loop) {
              //playing auto scroll to next sentence, not for loop mode
              _scrollController.safeScrollTo(
                spot?.playingSentenceIndex,
                alignment: 0.3,
              );
            }
          }
        },
      );
    });
  }

  void _listenToLoopSentenceEnd() {
    ref.listen(
      playerMediaProvider
          .select(
            (st) => st.value is PlayerMediaData
                ? (st.value as PlayerMediaData)
                : null,
          )
          .select((data) => data?.position_ms),
      (previous, position_ms) {
        if (position_ms == null) return;
        _videoPositionChanged(Duration(milliseconds: position_ms));
      },
    );
  }

  void _videoPositionChanged(Duration position) async {
    //handle loop seek to begin
    debugPrint('position change read loop provider');
    final loopSentence = await ref.read(
      playerLoopProvider.selectAsync((st) => st.loopSentence),
    );
    debugPrint('position changing loop $loopSentence');
    if (!_isDraggingVideoSlider && loopSentence != null) {
      //if repeat one is turn on, while sentence finished, seek to beginning
      // debugPrint('position changing loop $sentence');
      if (position > loopSentence.end) {
        debugPrint('position changing loop seek to ${loopSentence.start}');
        await ref.read(playerMediaProvider.notifier).seek(loopSentence.start);
      }
    }
  }

  Future<void> videoSliderStartChanged(
    double position_ms,
    double duration_ms,
  ) async {
    _isDraggingVideoSlider = true;
    _isPlayingBeforeDraged = ref.read(
      playerMediaControllerProvider.select((st) => st.playing),
    );
    debugPrint('slider: start');
    await ref.read(playerMediaProvider.notifier).pause();
    final position = Duration(milliseconds: position_ms.toInt());
    await ref.read(playerMediaProvider.notifier).seek(position);
  }

  Future<void> videoSliderChanging(
    double position_ms,
    double duration_ms,
  ) async {
    final position = Duration(milliseconds: position_ms.toInt());
    await ref.read(playerMediaProvider.notifier).seek(position);
  }

  Future<void> videoSliderEndChanged(
    double position_ms,
    double duration_ms,
  ) async {
    await defer(
      () async {
        _isDraggingVideoSlider = false;
        debugPrint('slider: end');
      },
      () async {
        final position = Duration(milliseconds: position_ms.toInt());
        // seek to sentence start
        final spot = ref.read(playerSpotProvider.select((st) => st.value));
        ref
            .read(playerLoopProvider.notifier)
            .updateIndexAndSentenceIfLoop(
              spot?.playingSentenceIndex!,
              spot?.playingSentence!,
            );
        final Duration seekToPosition;
        final playingSentenceStart = spot?.playingSentence?.start;
        if (_loop && playingSentenceStart != null) {
          debugPrint('slider end seek to sentence start $playingSentenceStart');
          seekToPosition = playingSentenceStart;
        } else {
          debugPrint('slider end seek to pos $position');
          seekToPosition = position;
        }
        await ref.read(playerMediaProvider.notifier).seek(seekToPosition);
        final duration = Duration(milliseconds: duration_ms.toInt());
        if (_isPlayingBeforeDraged && position < duration) {
          await ref.read(playerMediaProvider.notifier).play();
        }
      },
    );
  }

  void scrollToTop() {
    _scrollController.safeScrollTo(0);
  }

  void scrollToBottom() {
    _scrollController.safeScrollTo(_sentenceList.length - 1);
  }

  void scrollToPlayingSentence() {
    final index = ref.read(
      playerSpotProvider.select((st) => st.value?.playingSentenceIndex),
    );
    _scrollController.safeScrollTo(index, alignment: 0.3);
  }

  void tapSentence(String id) async {
    // if (id == null) return;
    // final sentenceIndex = _sentenceList.firstIndexWhereOrNull(
    //   (sen) => sen.id == id,
    // );
    // if (sentenceIndex == null) return;
    // /*Fix loop mode, tap sentence bug
    // in loop mode, you seek from s(n)->s(n+1),
    // because it beyond s(n) end, so it trigger reseek to start
    // same reason you seek from s(n)->s(n-1) will works perfectly,
    // so in loop mode, which sentence is loop wee need to manually maintain,
    // can't rely on position listening
    //  */
    // final sentence = _sentenceList[sentenceIndex];
    // debugPrint('tap id($id) index($sentenceIndex): ${sentence.text}');
    // if (_isLoop) {
    //   _scrollController.safeScrollTo(sentenceIndex, alignment: 0.3);
    //   ref
    //       .read(playerLoopProvider.notifier)
    //       .updateIndexAndSentenceIfLoop(sentenceIndex, sentence);
    // }
    // await ref.read(playerMediaProvider.notifier).seek(sentence.start);
    // await ref.read(playerMediaProvider.notifier).play();
  }

  Future<String?> _pickOneSubtitle() async {
    try {
      final subtitleExtensions = {'.srt', '.vtt'};
      final pickedFiles = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: [...subtitleExtensions],
      );
      final subtitlePath = pickedFiles?.files
          .firstWhereOrNull(
            (f) => f.path == null
                ? false
                : subtitleExtensions.contains(p.extension(f.path!)),
          )
          ?.path;
      return subtitlePath;
    } catch (e) {
      debugPrint('Error adding subtitle: $e');
      return null;
    }
  }
}
