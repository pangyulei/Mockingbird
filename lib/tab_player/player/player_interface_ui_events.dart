import 'package:flutter/cupertino.dart';
import 'player_state.dart';

abstract interface class PlayerInterfaceUIEvents {
  (bool, PlayerState) receiveNotification(PlayerState state, Notification notification);
}
