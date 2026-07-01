

enum AppTab {
  albums(0),
  player(1),
  settings(2);

  final int raw;

  const AppTab(this.raw);

  factory AppTab.fromRaw(int raw) {
    return AppTab.values.firstWhere(
      (e) => e.raw == raw,
      orElse: () => AppTab.albums,
    );
  }
}
