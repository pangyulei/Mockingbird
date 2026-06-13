import 'package:mockingbird/models/track.dart';


class PlayerState {
  final Track? track;
  const PlayerState({this.track});

  PlayerState copyWith({Track? track}) {
    return PlayerState(
      track: track ?? this.track,
    );
  }
}
