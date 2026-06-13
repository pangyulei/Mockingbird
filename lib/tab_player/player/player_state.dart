import 'package:mockingbird/models/track.dart';
import 'package:video_player/video_player.dart';


class PlayerState {
  final Track? track;
  final bool showLoading;
  final VideoPlayerController? playerController;
  const PlayerState({
    required this.showLoading,
    this.track,
    this.playerController,
  });

  PlayerState copyWith({
    Track? track,
    bool? showLoading,
    VideoPlayerController? playerController,
  }) {
    return PlayerState(
      track: track ?? this.track,
      showLoading: showLoading ?? this.showLoading,
      playerController: playerController ?? this.playerController,
    );
  }
}
