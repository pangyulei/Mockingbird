import 'package:flutter/material.dart';
import 'package:mockingbird/db/db.dart';
import 'package:mockingbird/tool/event_hub.dart';
import 'package:mockingbird/tool/shared_metadata.dart';

class AppLifecycler with WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    debugPrint('app state: $state');
    //退后台/锁屏 inactive->hidden->pause
    //回前台 pause->hidden->inactive->resumed
    if (state == .inactive) {
      EventHub.emit(const HubAppInactiveEvent());
      await DB.updateMetadata(SharedMetadata.instance);
    } else if (state == .resumed) {
      EventHub.emit(const HubAppResumeEvent());
    }
  }
}
