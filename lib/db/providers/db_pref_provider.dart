import 'package:mockingbird/db/db_logic.dart';
import 'package:mockingbird/db/entities/preference_entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'db_pref_provider.g.dart';

@Riverpod(name: 'dbPrefProvider')
class DBPref extends _$DBPref {
  @override
  Future<PreferenceEntity> build() async {
    final pref = await DBLogic().loadPref();
    if (pref == null) return PreferenceEntity.empty();
    return pref;
  }

  Future<void> setPlayingId(String id) async {
    final pref = await future;
    if (pref.playingId != id) {
      await edit((pref) => pref.copyWith(playingId: () => id));
    }
  }

  Future<void> edit(
    PreferenceEntity Function(PreferenceEntity pref) getter,
  ) async {
    final pref = await future;
    final updatedPref = getter(pref);
    if (updatedPref != pref) {
      await DBLogic().updatePref(updatedPref);
      ref.invalidateSelf();
    }
  }
}
