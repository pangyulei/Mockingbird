import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockingbird/db/entities/en_sentence.dart';
import 'package:mockingbird/db/providers/db_playing_media_provider.dart';
import 'package:mockingbird/tab_player/player/providers/player_setting_provider.dart';
import 'package:mockingbird/tab_player/player/providers/player_media_provider.dart';
import 'package:mockingbird/tab_player/player/states/player_subtitle_state.dart';
import 'package:mockingbird/tab_player/player/states/player_media_state.dart';
import 'package:mockingbird/tool/extensions.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:collection/collection.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../db/entities/en_media.dart';
import '../../../db/entities/en_subtitle.dart';
import '../../../db/providers/db_album_list_provider.dart';
import '../../../tool/subtitle_parser.dart';

part 'player_subtitle_provider.g.dart';

@riverpod
class PlayerSubtitle extends _$PlayerSubtitle {
  final _scrollController = ItemScrollController();
  int? _playingSentenceIndex;
  List<EnSentence> _sentenceList = [];
  @override
  PlayerSubtitleState build() {
    final positionMicro = ref.watch(
      playerMediaProvider.select((st) {
        final data = st.value;
        if (data is! PlayerMediaData) return null;
        return data.positionMicro;
      }),
    );
    if (positionMicro == null) return PlayerSubtitleState.empty(_scrollController);
    final EnSubtitle? subtitle = ref.watch(
      dbPlayingMediaProvider.select((st) => st.value?.subtitleList.firstOrNull),
    );
    if (subtitle == null) return PlayerSubtitleState.empty(_scrollController);
    _sentenceList = subtitle.sentenceList;
    final playingSentenceIndex = _sentenceIndexByPosition(
      Duration(microseconds: positionMicro),
      subtitle.sentenceList,
    );
    _playingSentenceIndex = playingSentenceIndex;
    final playingSentenceId = playingSentenceIndex == null
        ? null
        : subtitle.sentenceList[playingSentenceIndex].id;
    return PlayerSubtitleState(
      playingSentenceId: playingSentenceId,
      scrollController: _scrollController,
      sentenceIdList: subtitle.sentenceList.map((sen) => sen.id).toList(),
    );
  }

  int? get playingSentenceIndex => _playingSentenceIndex;

  EnSentence? get loopSentence {
    final isLoop = ref.watch(
      playerSettingProvider.select((st) => st.value?.isLoop),
    );
    if (isLoop == null) return null;
    if (!isLoop) return null;
    final playingSentenceIndex = _playingSentenceIndex;
    if (playingSentenceIndex == null) return null;
    return _sentenceList[playingSentenceIndex];
  }

  void scrollToTop() {
    _scrollController.safeScrollTo(0);
  }

  void scrollToBottom() {
    _scrollController.safeScrollTo(_sentenceList.length - 1);
  }

  void scrollToPlayingSentence() {
    _scrollController.safeScrollTo(_playingSentenceIndex, alignment: 0.3);
  }

  void jumpToPlayingSentence() {
    _scrollController.safeJumpTo(_playingSentenceIndex, alignment: 0.3);
  }

  void tapSentence(int? id) async {
    if (id == null) return;
    final sentenceIndex = _sentenceList.firstIndexWhereOrNull(
      (sen) => sen.id == id,
    );
    if (sentenceIndex == null) return;
    final sentence = _sentenceList[sentenceIndex];
    await ref.read(playerMediaProvider.notifier).seekTo(sentence.start);
    ref.read(playerSubtitleProvider.notifier).scrollToPlayingSentence();
    ref.read(playerMediaProvider.notifier).play();
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

  int? _sentenceIndexByPosition(
    Duration position,
    List<EnSentence> sentenceList,
  ) {
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
