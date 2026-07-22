import 'package:mockingbird/tab_settings/settings_provider.dart';

sealed class SettingsState {
  const SettingsState();
}

class SettingsData extends SettingsState {
  final bool isLoop;
  const SettingsData({required this.isLoop});

  SettingsData copyWith({bool? isLoop}) {
    return SettingsData(isLoop: isLoop ?? this.isLoop);
  }
}
