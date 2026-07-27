import 'package:collection/collection.dart';
import 'package:mockingbird/db/providers/db_playing_media_provider.dart';
import 'package:mockingbird/tab_player/player/states/player_subtitle_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'player_subtitle_provider.g.dart';

@riverpod
class PlayerSubtitle extends _$PlayerSubtitle {
  @override
  Future<PlayerSubtitleState> build() async {
    final sentenceList = await ref.watch(
      dbPlayingMediaProvider.selectAsync(
        (st) => st?.subtitleList.firstOrNull?.sentenceList,
      ),
    );

    if (sentenceList == null || sentenceList.isEmpty) {
      return const PlayerSubtitleNull();
    }
    return PlayerSubtitleData(sentenceList: sentenceList);
  }

}
