
import 'package:video_player/video_player.dart';

sealed class PlayerMediaState {
  const PlayerMediaState();
}
class PlayerMediaNull extends PlayerMediaState {
  const PlayerMediaNull();
}

class PlayerMediaData extends PlayerMediaState {
  final VideoPlayerController videoController;
  final bool isPlaying;
  final int positionMicro;

  const PlayerMediaData({
    required this.positionMicro,
    required this.isPlaying,
    required this.videoController,
  });

  PlayerMediaData copyWith({
    int? positionMicro,
    bool? isPlaying,
  }) {
    return PlayerMediaData(
      positionMicro: positionMicro ?? this.positionMicro,
      videoController: videoController,
      isPlaying: isPlaying ?? this.isPlaying,
    );
  }
}