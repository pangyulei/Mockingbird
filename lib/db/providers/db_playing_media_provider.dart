import 'package:mockingbird/db/providers/db_media_provider.dart';
import 'package:mockingbird/db/providers/db_pref_provider.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'db_playing_media_provider.g.dart';

@Riverpod(name: 'dbPlayingMediaProvider')
class DBPlayingMedia extends _$DBPlayingMedia {
  @override
  Future<AssetEntity?> build() async {
    final String? playingId = await ref.watch(
      dbPrefProvider.selectAsync((st) => st.playingId),
    );
    return await ref.watch(dbMediaProvider(playingId).future);
  }
}
