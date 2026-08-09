import 'package:mockingbird/db/providers/db_playing_subtitle_provider.dart';
import 'package:mockingbird/tab_player/player/states/player_subtitle_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'player_subtitle_provider.g.dart';

@riverpod
class PlayerSubtitle extends _$PlayerSubtitle {
  @override
  Future<PlayerSubtitleState> build() async {
    final subtitle = await ref.watch(dbPlayingSubtitleProvider.future);
    if (subtitle == null) return const PlayerSubtitleNull();
    return PlayerSubtitleData(
      sentenceIdList: subtitle.sentenceList.map((s) => s.id).toList(),
    );
  }
}
