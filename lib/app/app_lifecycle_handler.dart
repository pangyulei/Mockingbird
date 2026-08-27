import 'package:flutter/material.dart';
import 'package:mockingbird/tool/event_hub.dart';

class AppLifecycleHandler with WidgetsBindingObserver {
  AppLifecycleHandler();

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    debugPrint('app state: $state');
    //退后台/锁屏 inactive->hidden->pause
    //回前台 pause->hidden->inactive->resumed
    if (state == AppLifecycleState.paused) {
      EventHub.emit(const HubAppPauseEvent());
    }
  }
}
