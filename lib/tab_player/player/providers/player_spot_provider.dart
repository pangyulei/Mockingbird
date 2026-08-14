import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:mockingbird/db/providers/db_playing_subtitle_provider.dart';
import 'package:mockingbird/db/providers/db_subtitle_provider.dart';
import 'package:mockingbird/tab_player/player/providers/player_media_provider.dart';
import 'package:mockingbird/tab_player/player/states/player_media_state.dart';
import 'package:mockingbird/tab_player/player/states/player_spot_state.dart';
import 'package:mockingbird/tool/subtitle_parser.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../db/entities/sentence_entity.dart';
import '../../../tool/extensions.dart';

part 'player_spot_provider.g.dart';

@riverpod
class PlayerSpot extends _$PlayerSpot {
  @override
  Future<PlayerSpotState?> build() async {
    final position = await ref.watch(
      playerMediaProvider.selectAsync((st) => st.as<PlayerMediaData>()?.position),
    );
    
    if (position == null) {
      return null;
    }
    final List<SentenceEntity>? sentenceList = await ref.watch(
      dbPlayingSubtitleProvider.selectAsync((st) => st?.sentenceList),
    );
    if (sentenceList == null || sentenceList.isEmpty) {
      return null;
    }
    final playingSentenceIndex = _sentenceIndexByPosition(position, sentenceList);
    final playingSentence = playingSentenceIndex == null
        ? null
        : sentenceList[playingSentenceIndex];
    debugPrint('spot: ($playingSentenceIndex) $playingSentence');
    return PlayerSpotState(
      playingSentenceIndex: playingSentenceIndex,
      playingSentence: playingSentence,
    );
  }

  int? _sentenceIndexByPosition(Duration position, List<SentenceEntity> sentenceList) {
    for (int i = 0; i < sentenceList.length; i++) {
      SentenceEntity? prev = i == 0 ? null : sentenceList[i - 1];
      SentenceEntity? next = sentenceList.elementAtOrNull(i + 1);
      SentenceEntity sentence = sentenceList[i];
      if (sentence.playing(prev, next, position)) {
        return i;
      }
    }
    return null;
  }
}

extension on SentenceEntity {
  bool playing(SentenceEntity? prev, SentenceEntity? next, Duration position) {
    final start = prev == null ? const Duration(seconds: 0) : this.start;
    if (next == null) {
      return start <= position;
    } else {
      return start <= position && position < next.start;
    }
  }
}
