import 'package:flutter/widgets.dart';
import 'package:mockingbird/app/app_interface_ui_events.dart';
import 'package:mockingbird/app/app_state.dart';
import '../notifications/notification_play_track.dart';

class AppHandler implements AppInterfaceUIEvents {
  const AppHandler();

  @override
  AppState appSwitchToTab(AppState state, AppTab tab) {
    return AppState(tab);
  }

  @override
  AppState appInitState() {
    return const AppState(AppTab.playlists);
  }

  @override
  (bool, AppState) appReceiveNotification(AppState state, Notification notification) {
    if (notification is NotificationPlayTrack) {
      // TODO: Here we should also notify PlayerLogic to load the track.
      // But for now, we just switch the tab.
      return (true, const AppState(AppTab.player));
    } else {
      return (false, state);
    }
  }
}
