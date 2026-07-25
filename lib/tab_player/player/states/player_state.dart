sealed class PlayerState {
  const PlayerState();
}

class PlayerNull extends PlayerState {
  const PlayerNull();
}

class PlayerData extends PlayerState {
  final String title;

  const PlayerData({required this.title});

  PlayerData copyWith({String? title}) {
    return PlayerData(title: title ?? this.title);
  }
}
