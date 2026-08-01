import 'package:mockingbird/tab_player/player/providers/player_media_controller.dart';

sealed class PlayerMediaState {
  const PlayerMediaState();
}

class PlayerMediaNull extends PlayerMediaState {
  const PlayerMediaNull();
}

class PlayerMediaData extends PlayerMediaState {
  final PlayerMediaControllerITF mediaController;
  final bool isPlaying;
  final int positionMicro;

  const PlayerMediaData({
    required this.positionMicro,
    required this.isPlaying,
    required this.mediaController,
  });

  PlayerMediaData copyWith({int? positionMicro, bool? isPlaying}) {
    return PlayerMediaData(
      positionMicro: positionMicro ?? this.positionMicro,
      mediaController: mediaController,
      isPlaying: isPlaying ?? this.isPlaying,
    );
  }
}
