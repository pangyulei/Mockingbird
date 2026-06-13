
class AppState {
  final AppTab selectedTab;

  const AppState(this.selectedTab);
}

enum AppTab {
  playlists(0),
  player(1),
  settings(2);

  final int raw;
  const AppTab(this.raw);

  static AppTab fromRaw(int raw) {
    return AppTab.values.firstWhere(
          (v) => v.raw == raw,
      orElse: () => AppTab.playlists,
    );
  }
}
