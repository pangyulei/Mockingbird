import 'package:collection/collection.dart';
import 'package:mockingbird/db/providers/db_playing_subtitle_list_provider.dart';
import 'package:mockingbird/tab_player/player/providers/player_selected_subtitle_id_provider.dart';
import 'package:mockingbird/tab_player/player/states/player_subtitle_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'player_subtitle_provider.g.dart';

@riverpod
class PlayerSubtitle extends _$PlayerSubtitle {
  @override
  Future<PlayerSubtitleState> build() async {
    final selectedSubtitleId = ref.watch(playerSelectedSubtitleIdProvider);
    if (selectedSubtitleId == null) {
      return const PlayerSubtitleNull();
    }
    final subtitleList = await ref.watch(dbPlayingSubtitleListProvider.future);
    final selectedSubtitle = subtitleList.firstWhereOrNull(
      (s) => s.id == selectedSubtitleId,
    );
    if (selectedSubtitle == null) return const PlayerSubtitleNull();
    return PlayerSubtitleData(
      sentenceIdList: selectedSubtitle.sentenceList.map((s) => s.id).toList(),
    );
  }
}
