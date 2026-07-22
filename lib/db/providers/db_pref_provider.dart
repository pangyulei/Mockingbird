import 'package:mockingbird/db/db_logic.dart';
import 'package:mockingbird/db/entities/en_pref.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'db_pref_provider.g.dart';

@Riverpod(keepAlive: true, name: 'dbPrefProvider')
class DBPref extends _$DBPref {
  @override
  Future<EnPref> build() async {
    return await DBLogic().loadPref() ?? EnPref.empty();
  }

  Future<void> setPlayingId(int? id) async {
    final pref = await future;
    if (pref.playingId != id) {
      state = await AsyncValue.guard(() async {
        final updatedPref = await DBLogic().updatePref(
          pref.copyWith(getPlayingId: () => id),
        );
        return updatedPref;
      });
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
