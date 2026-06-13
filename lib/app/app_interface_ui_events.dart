import 'package:flutter/cupertino.dart';
import 'package:mockingbird/app/app_state.dart';

abstract interface class AppInterfaceUIEvents {
  AppState appInitState();
  AppState appSwitchToTab(AppState state, AppTab tab);
  (bool, AppState) appReceiveNotification(AppState state, Notification notification);
}
