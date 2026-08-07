import 'package:mockingbird/db/providers/db_preference_provider.dart';
import 'package:mockingbird/tab_settings/settings_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'settings_provider.g.dart';

@riverpod
class Settings extends _$Settings {
  @override
  Future<SettingsState> build() async {
    final preference = await ref.watch(dbPreferenceProvider.future);
    return SettingsState(loop: preference.loop);
  }

  Future<void> toggleLoop() async {
    await ref.read(dbPreferenceProvider.notifier).toggleLoop();
  }
}
