import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockingbird/tab_player/player/states/player_subtitle_list_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../db/providers/db_playing_subtitle_list_provider.dart';

part 'player_subtitle_list_provider.g.dart';

@riverpod
class PlayerSubtitleList extends _$PlayerSubtitleList {
  @override
  PlayerSubtitleListState build() {
    final subtitleList = ref.watch(dbPlayingSubtitleListProvider.select((st) => st.value));
    return PlayerSubtitleListState(
      subtitleNameList: subtitleList?.map((s) => s.name).toList() ?? [],
    );
  }
}
