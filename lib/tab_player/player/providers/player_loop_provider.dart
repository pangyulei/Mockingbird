import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockingbird/db/entities/en_sentence.dart';
import 'package:mockingbird/db/providers/db_pref_provider.dart';
import 'package:mockingbird/tab_player/player/providers/player_spot_provider.dart';
import 'package:mockingbird/tab_player/player/providers/player_subtitle_provider.dart';
import 'package:mockingbird/tab_player/player/states/player_loop_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'player_loop_provider.g.dart';

@riverpod
class PlayerLoop extends _$PlayerLoop {
  @override
  Future<PlayerLoopState> build() async {
    final prefIsLoop = await ref.read(
      dbPrefProvider.selectAsync((st) => st.isLoop),
    );
    final spot = await ref.read(playerSpotProvider.future);
    return PlayerLoopState(
      isLoop: prefIsLoop,
      loopIndex: prefIsLoop ? spot?.playingSentenceIndex : null,
      loopSentence: prefIsLoop ? spot?.playingSentence : null,
    );
  }

  void toggleLoop() {
    final isLoop = state.value?.isLoop;
    if (isLoop == null) return;
    final data = state.value;
    if (data == null) return;
    final newIsLoop = !isLoop;
    final spot = ref.read(playerSpotProvider.select((st) => st.value));
    state = AsyncData(
      data.copyWith(
        isLoop: newIsLoop,
        loopIndex: () => newIsLoop ? spot?.playingSentenceIndex : null,
        loopSentence: () => newIsLoop ? spot?.playingSentence : null,
      ),
    );
  }

  void updateIndexAndSentenceIfLoop(int? index, EnSentence? sentence) {
    final data = state.value;
    if (data == null) return;
    if (!data.isLoop) return;
    state = AsyncData(
      data.copyWith(loopIndex: () => index, loopSentence: () => sentence),
    );
  }
}
