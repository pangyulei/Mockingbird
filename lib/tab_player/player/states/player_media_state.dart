import 'package:mockingbird/tab_player/player/player_media_controller.dart';

sealed class PlayerMediaState {
  const PlayerMediaState();
}

class PlayerMediaNull extends PlayerMediaState {
  const PlayerMediaNull();
}

class PlayerMediaData extends PlayerMediaState {
  final PlayerMediaControllerITF mediaController;
  final bool playing;
  final int position_ms;

  const PlayerMediaData({
    required this.position_ms,
    required this.playing,
    required this.mediaController,
  });

  PlayerMediaData copyWith({int? position_ms, bool? playing}) {
    return PlayerMediaData(
      position_ms: position_ms ?? this.position_ms,
      mediaController: mediaController,
      playing: playing ?? this.playing,
    );
  }
}
