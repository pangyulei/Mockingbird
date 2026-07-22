import 'package:mockingbird/db/providers/db_pref_provider.dart';
import 'package:mockingbird/tab_settings/settings_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'settings_provider.g.dart';

@riverpod
class Settings extends _$Settings {
  @override
  Future<SettingsState> build() async {
    final pref = await ref.watch(dbPrefProvider.future);
    return SettingsData(isLoop: pref.isLoop);
  }

  Future<void> toggleLoop() async {
    final data = await future;
    if (data is! SettingsData) return;
    await ref
        .read(dbPrefProvider.notifier)
        .updatePref((pref) => pref.copyWith(isLoop: !data.isLoop));
  }
}
