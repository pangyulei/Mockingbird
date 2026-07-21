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
          pref.copyWith(playingId: () => id),
        );
        return updatedPref;
      });
    }
  }

  Future<void> setLoop(bool value) async {
    final pref = await future;
    if (pref.loop != value) {
      state = await AsyncValue.guard(() async {
        final updatedPref = await DBLogic().updatePref(
          pref.copyWith(loop: value),
        );
        return updatedPref;
      });
    }
  }
}
