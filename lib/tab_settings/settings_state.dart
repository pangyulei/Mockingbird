
class SettingsState {
  final bool isLoop;
  const SettingsState({required this.isLoop});

  SettingsState copyWith({bool? isLoop}) {
    return SettingsState(isLoop: isLoop ?? this.isLoop);
  }
}
