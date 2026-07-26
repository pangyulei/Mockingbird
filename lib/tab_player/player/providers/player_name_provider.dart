import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockingbird/db/providers/db_playing_media_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'player_name_provider.g.dart';
@riverpod
class PlayerTitle extends _$PlayerTitle {
  @override
  String build() {
    final String mediaName =
        ref.watch(dbPlayingMediaProvider.select((st) => st.value?.name ?? ''));
    return mediaName;
  }
}
