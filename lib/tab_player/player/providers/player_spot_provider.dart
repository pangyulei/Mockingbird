import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:mockingbird/db/entities/en_sentence.dart';
import 'package:mockingbird/tab_player/player/providers/player_media_provider.dart';
import 'package:mockingbird/tab_player/player/providers/player_subtitle_provider.dart';
import 'package:mockingbird/tab_player/player/states/player_media_state.dart';
import 'package:mockingbird/tab_player/player/states/player_spot_state.dart';
import 'package:mockingbird/tab_player/player/states/player_subtitle_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../tool/extensions.dart';

part 'player_spot_provider.g.dart';

@riverpod
class PlayerSpot extends _$PlayerSpot {
  @override
  Future<PlayerSpotState?> build() async {
    final int? position_ms = await ref.watch(
      playerMediaProvider.selectAsync((st) {
        if (st is! PlayerMediaData) return null;
        return st.position_ms;
      }),
    );
    if (position_ms == null) {
      return null;
    }
    final List<EnSentence>? sentenceList = await ref.watch(
      playerSubtitleProvider.selectAsync(
        (st) => st.as<PlayerSubtitleData>()?.sentenceList,
      ),
    );
    if (sentenceList == null) {
      return null;
    }
    final position = Duration(milliseconds: position_ms);
    final playingSentenceIndex = _sentenceIndexByPosition(
      position,
      sentenceList,
    );
    final playingSentence = playingSentenceIndex == null
        ? null
        : sentenceList[playingSentenceIndex];
    debugPrint('spot: ($playingSentenceIndex) $playingSentence');
    return PlayerSpotState(
      playingSentenceIndex: playingSentenceIndex,
      playingSentence: playingSentence,
    );
  }

  int? _sentenceIndexByPosition(
    Duration position,
    List<EnSentence> sentenceList,
  ) {
    for (int i = 0; i < sentenceList.length; i++) {
      EnSentence? prev = i == 0 ? null : sentenceList[i - 1];
      EnSentence? next = sentenceList.elementAtOrNull(i + 1);
      EnSentence sentence = sentenceList[i];
      if (sentence.playing(prev, next, position)) {
        return i;
      }
    }
    return null;
  }
}

extension on EnSentence {
  bool playing(EnSentence? prev, EnSentence? next, Duration position) {
    final start = prev == null ? const Duration(seconds: 0) : this.start;
    if (next == null) {
      return start <= position;
    } else {
      return start <= position && position < next.start;
    }
  }
}
