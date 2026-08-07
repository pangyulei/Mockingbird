import 'package:flutter/cupertino.dart';
import 'package:mockingbird/db/db_logic.dart';
import 'package:mockingbird/db/entities/preference_entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'db_preference_provider.g.dart';

@Riverpod(name: 'dbPreferenceProvider')
class DBPreference extends _$DBPreference {
  @override
  Future<PreferenceEntity> build() async {
    debugPrint('pref provider build');
    ref.onDispose(() {
      debugPrint('pref provider dispose');
    });
    final preference = await DBLogic().loadPreference();
    debugPrint('pref provider built');
    return preference ?? PreferenceEntity.empty();
  }

  Future<void> toggleLoop() async {
    await _updatePreference((pref) => pref.copyWith(loop: !pref.loop));
  }

  Future<void> _updatePreference(
    PreferenceEntity Function(PreferenceEntity pref) getter,
  ) async {
    final pref = await future;
    debugPrint('pref provider state got');
    final updatedPref = getter(pref);
    if (updatedPref != pref) {
      await DBLogic().updatePreference(updatedPref);
      state = AsyncData(updatedPref);
    }
    debugPrint('pref provider updated');
  }
}
