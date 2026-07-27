import 'package:mockingbird/db/db_logic.dart';
import 'package:mockingbird/db/entities/en_pref.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'db_pref_provider.g.dart';

@Riverpod(name: 'dbPrefProvider')
class DBPref extends _$DBPref {
  @override
  Future<EnPref> build() async {
    final pref = await DBLogic().loadPref();
    if (pref == null) return EnPref.empty();
    return pref;
  }

  Future<void> setPlayingId(int? id) async {
    final pref = await future;
    if (pref.playingId != id) {
      await edit((pref) => pref.copyWith(playingId: () => id));
    }
  }

  Future<void> updateByMediaDeleted(List<int> mediaIdList) async {
    //update pref playing media id if need
    final playingId = (await future).playingId;
    if (playingId != null && mediaIdList.contains(playingId)) {
      await setPlayingId(null);
    }
  }

  Future<void> edit(EnPref Function(EnPref pref) getter) async {
    final pref = await future;
    final updatedPref = getter(pref);
    if (updatedPref != pref) {
      await DBLogic().updatePref(updatedPref);
      ref.invalidateSelf();
    }
  }
}
