import '../models/track.dart';

abstract class GlobalEvent {
  const GlobalEvent();
}

class GlobalEventPlayTrack extends GlobalEvent {
  final Track track;
  const GlobalEventPlayTrack(this.track);
}