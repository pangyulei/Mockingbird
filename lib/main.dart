import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:mockingbird/app/app_lifecycler.dart';
import 'package:mockingbird/app/app_ui.dart';
import 'package:mockingbird/db/db.dart';
import 'package:mockingbird/tab_player/player/background_audio_player.dart';
import 'package:mockingbird/tool/shared_metadata.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); //objectbox official code
  await DB.init();
  await SharedMetadata.init();
  await AudioService.init(
    builder: () => BackgroundAudioPlayer(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.raypang.mockingbird.background_audio',
      androidNotificationChannelName: 'Mockingbird',
      androidStopForegroundOnPause: false,
      androidNotificationIcon: 'mipmap/ic_launcher',
      androidShowNotificationBadge: true,
    ),
  );
  WidgetsBinding.instance.addObserver(AppLifecycler());
  runApp(const AppUI());
}
