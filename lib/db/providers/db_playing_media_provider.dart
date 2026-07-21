import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockingbird/db/db_logic.dart';
import 'package:mockingbird/db/entities/en_media.dart';
import 'package:mockingbird/db/providers/db_pref_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'db_playing_media_provider.g.dart';

@riverpod
class PlayingMedia extends _$PlayingMedia {
  @override
  Future<EnMedia?> build() async {
    final int? playingId = ref.watch(
      dbPrefProvider.select((st) => st.value?.playingId),
    );
    if (playingId == null) return null;
    return await DBLogic().loadMedia(playingId);
  }
}
