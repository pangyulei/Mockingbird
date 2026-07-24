import 'package:mockingbird/tab_player/player/player_video.dart';

sealed class PlayerState {
  const PlayerState();
}

class PlayerNull extends PlayerState {
  const PlayerNull();
}

class PlayerData extends PlayerState {
  final String title;
  final PlayerVideo video;

  const PlayerData({required this.video, required this.title});

  PlayerData copyWith({String? title, PlayerVideo? video}) {
    return PlayerData(title: title ?? this.title, video: video ?? this.video);
  }
}
