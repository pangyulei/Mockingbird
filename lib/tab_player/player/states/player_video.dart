
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:video_player/video_player.dart';

class PlayerVideo {
  final VideoPlayerController videoController;
  final bool isPlaying;
  final int positionMicro;

  const PlayerVideo({
    required this.positionMicro,
    required this.isPlaying,
    required this.videoController,
  });

  PlayerVideo copyWith({
    int? positionMicro,
    bool? isPlaying,
  }) {
    return PlayerVideo(
      positionMicro: positionMicro ?? this.positionMicro,
      videoController: videoController,
      isPlaying: isPlaying ?? this.isPlaying,
    );
  }
}