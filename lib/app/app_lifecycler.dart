import 'package:flutter/material.dart';
import 'package:mockingbird/tool/event_hub.dart';

class AppLifecycler with WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    debugPrint('app state: $state');
    //退后台/锁屏 inactive->hidden->pause
    //回前台 pause->hidden->inactive->resumed
    if (state == .inactive) {
      EventHub.emit(const HubAppInactiveEvent());
    } else if (state == .resumed) {
      EventHub.emit(const HubAppResumeEvent());
    } else if (state == .paused) {
      EventHub.emit(const HubAppPauseEvent());
    }
  }
}
