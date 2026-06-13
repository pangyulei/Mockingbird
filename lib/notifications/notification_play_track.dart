import 'package:flutter/widgets.dart';
import '../models/track.dart';

/// A notification that travels up the widget tree to trigger a tab change and play a track.
class NotificationPlayTrack extends Notification {
  final Track track;
  const NotificationPlayTrack(this.track);
}
