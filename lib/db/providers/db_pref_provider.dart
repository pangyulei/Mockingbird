import 'package:mockingbird/db/db_logic.dart';
import 'package:mockingbird/db/entities/en_pref.dart';
import 'package:mockingbird/db/providers/db_media_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'db_pref_provider.g.dart';

@Riverpod(keepAlive: true, name: 'dbPrefProvider')
class DBPref extends _$DBPref {
  @override
  Future<EnPref> build() async {
    final pref = await DBLogic().loadPref() ?? EnPref.empty();
    if (pref.playingId != null) {
      final playingMedia = await ref.watch(
        dbMediaProvider(pref.playingId).future,
      );
      if (playingMedia == null) {
        setPlayingId(null);
      }
    }
    return pref;
  }

  Future<void> setPlayingId(int? id) async {
    final pref = await future;
    if (pref.playingId != id) {
      await DBLogic().updatePref(pref.copyWith(playingId: () => id));
      ref.invalidateSelf();
    }
  }

  Future<void> updatePref(EnPref Function(EnPref pref) getPref) async {
    final pref = await future;
    final updatedPref = getPref(pref);
    if (updatedPref != pref) {
      state = await AsyncValue.guard(() async {
        return await DBLogic().updatePref(updatedPref);
      });
    }
  }
}
