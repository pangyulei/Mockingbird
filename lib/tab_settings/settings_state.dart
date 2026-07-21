class SettingsState {
  final bool loop;

  const SettingsState({required this.loop});

  SettingsState copyWith({bool? loop}) {
    return SettingsState(loop: loop ?? this.loop);
  }
}
