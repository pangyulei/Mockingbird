
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:mockingbird/mobile/app/mobile_app_lifecycler.dart';
import 'package:mockingbird/mobile/app/mobile_app_ui.dart';
import 'package:mockingbird/mobile/db/db.dart';
import 'package:mockingbird/mobile/tab_player/player/background_audio_player.dart';
import 'package:mockingbird/tool/extensions.dart';

import 'desktop/desktop_app_ui.dart';

void main() async {
  switch (kPlatformType) {
    case .desktop:
      await _runDesktopApp();
    default:
      await _runMobileApp();
  }
}

Future<void> _runDesktopApp() async {
  WidgetsFlutterBinding.ensureInitialized(); //objectbox official code
  await DB.init();
  runApp(const DesktopAppUI());
}

Future<void> _runMobileApp() async {
  WidgetsFlutterBinding.ensureInitialized(); //objectbox official code
  await DB.init();
  await AudioService.init(
    builder: () => MobileBackgroundAudioPlayer(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.raypang.mockingbird.background_audio',
      androidNotificationChannelName: 'Mockingbird',
      androidStopForegroundOnPause: false,
      androidNotificationIcon: 'mipmap/ic_launcher',
      androidShowNotificationBadge: true,
    ),
  );
  WidgetsBinding.instance.addObserver(MobileAppLifecycler());
  runApp(const MobileAppUI());
}
