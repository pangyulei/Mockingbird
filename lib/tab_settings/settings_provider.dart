import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mockingbird/db/providers/db_pref_provider.dart';
import 'package:mockingbird/tab_settings/settings_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'settings_provider.g.dart';

@riverpod
class Settings extends _$Settings {
  @override
  Future<SettingsState> build() async {
    EasyLoading.show(maskType: .clear);

    final pref = await ref.watch(dbPrefProvider.future);

    EasyLoading.dismiss();
    return SettingsState(loop: pref.loop);
  }

  Future<void> toggleLoop() async {
    final val = await future;
    // state = AsyncData(val.copyWith(loop: !val.loop));
    await ref.read(dbPrefProvider.notifier).setLoop(!val.loop);
  }
}
