import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockingbird/db/providers/db_preference_provider.dart';
import 'package:mockingbird/tab_player/player/providers/player_spot_provider.dart';
import 'package:mockingbird/tab_player/player/states/player_loop_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../db/entities/sentence_entity.dart';

part 'player_loop_provider.g.dart';

@riverpod
class PlayerLoop extends _$PlayerLoop {
  @override
  Future<PlayerLoopState> build() async {
    final preferenceLoop = await ref.read(
      dbPreferenceProvider.selectAsync((st) => st.loop),
    );
    final spot = await ref.read(playerSpotProvider.future);
    return PlayerLoopState(
      loop: preferenceLoop,
      loopIndex: preferenceLoop ? spot?.playingSentenceIndex : null,
      loopSentence: preferenceLoop ? spot?.playingSentence : null,
    );
  }

  void toggleLoop() {
    final loop = state.value?.loop;
    if (loop == null) return;
    final data = state.value;
    if (data == null) return;
    final newLoop = !loop;
    final spot = ref.read(playerSpotProvider.select((st) => st.value));
    state = AsyncData(
      data.copyWith(
        loop: newLoop,
        loopIndex: () => newLoop ? spot?.playingSentenceIndex : null,
        loopSentence: () => newLoop ? spot?.playingSentence : null,
      ),
    );
  }

  void updateIndexAndSentenceIfLoop(int? index, SentenceEntity? sentence) {
    final data = state.value;
    if (data == null) return;
    if (!data.loop) return;
    state = AsyncData(
      data.copyWith(loopIndex: () => index, loopSentence: () => sentence),
    );
  }
}
