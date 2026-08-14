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
  final Duration position;
  final Duration duration;

  const PlayerMediaData({
    required this.position,
    required this.duration,
    required this.playing,
    required this.mediaController,
  });

  PlayerMediaData copyWith({Duration? position, Duration? duration, bool? playing}) {
    return PlayerMediaData(
      position: position ?? this.position,
      duration: duration ?? this.duration,
      mediaController: mediaController,
      playing: playing ?? this.playing,
    );
  }
}
