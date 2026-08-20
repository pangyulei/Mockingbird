import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:mockingbird/app/app_lifecycle_handler.dart';
import 'package:mockingbird/app/app_ui.dart';
import 'package:mockingbird/db/db.dart';
import 'package:mockingbird/tab_player/player/background_audio.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); //objectbox official code
  await DB.init();
  MediaKit.ensureInitialized();
  await AudioService.init(
    builder: () => SharedBackgroundAudio.audio,
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.raypang.mockingbird.background_audio',
      androidNotificationChannelName: 'Mockingbird',
      androidStopForegroundOnPause: false,
      androidNotificationIcon: 'mipmap/ic_launcher',
      androidShowNotificationBadge: true,
    ),
  );
  WidgetsBinding.instance.addObserver(AppLifecycleHandler());
  runApp(const AppUI());
}
