
import 'package:flutter/cupertino.dart';
import '../../notifications/notification_play_track.dart';
import 'player_interface_ui_events.dart';
import 'player_state.dart';

class PlayerLogic implements PlayerInterfaceUIEvents {
  const PlayerLogic();

  @override
  (bool, PlayerState) receiveNotification(PlayerState state, Notification notification) {
    if (notification is NotificationPlayTrack) {
      return (true, state.copyWith(track: notification.track));
    } else {
      return (false, state);
    }
  }
}
