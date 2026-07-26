import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockingbird/db/entities/en_sentence.dart';
import 'package:mockingbird/db/providers/db_playing_media_provider.dart';
import 'package:mockingbird/tab_player/player/providers/player_media_provider.dart';
import 'package:mockingbird/tab_player/player/providers/player_setting_provider.dart';
import 'package:mockingbird/tab_player/player/states/player_media_state.dart';
import 'package:mockingbird/tab_player/player/states/player_spot_state.dart';

final playerSpotProvider = NotifierProvider(
  PlayerSpotNotifier.new,
);

class PlayerSpotNotifier extends Notifier<PlayerSpotState> {
 
  @override
  PlayerSpotState build() {
    final positionMicro = ref.watch(
      playerMediaProvider.select((st) {
        final data = st.value;
        if (data is! PlayerMediaData) return null;
        return data.positionMicro;
      }),
    );
    if (positionMicro == null) {
      return const PlayerSpotState.empty();
    }
    final List<EnSentence>? sentenceList = ref.watch(
      dbPlayingMediaProvider.select(
        (st) => st.value?.subtitleList.firstOrNull?.sentenceList,
      ),
    );
    if (sentenceList == null) {
      return const PlayerSpotState.empty();
    }
    final position = Duration(microseconds: positionMicro);
    final playingSentenceIndex = _sentenceIndexByPosition(
      position,
      sentenceList,
    );
    final playingSentence = playingSentenceIndex == null
        ? null
        : sentenceList[playingSentenceIndex];
    return PlayerSpotState(
      playingSentenceIndex: playingSentenceIndex,
      playingSentence: playingSentence,
    );
  }

  EnSentence? get loopSentence {
    final isLoop = ref.read(
      playerSettingProvider.select((st) => st.value?.isLoop),
    );
    if (isLoop == null || !isLoop) return null;
    return state.playingSentence;
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
