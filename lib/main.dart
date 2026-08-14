import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_kit/media_kit.dart';
import 'package:mockingbird/app/app_lifecycle_handler.dart';
import 'package:mockingbird/app/app_ui.dart';
import 'package:mockingbird/db/db_objectbox.dart';
import 'package:mockingbird/tab_player/player/providers/background_audio_handler_provider.dart';
import 'package:mockingbird/tool/logger_observer.dart';
import 'package:riverpod_devtools/riverpod_devtools.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); //objectbox official code
  await DBObjectBox.init();
  MediaKit.ensureInitialized();
  final providerContainer = ProviderContainer(
      observers: [
        // RiverpodDevToolsObserver(),
        // LoggerObserver(),
      ],
  );
  final backgroundAudioHandler = providerContainer.read(
    backgroundAudioHandlerProvider,
  );
  await AudioService.init(
    builder: () => backgroundAudioHandler,
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.raypang.mockingbird.background_audio',
      androidNotificationChannelName: 'Mockingbird',
      androidStopForegroundOnPause: false,
      androidNotificationIcon: 'mipmap/ic_launcher',
      androidShowNotificationBadge: true,
    ),
  );
  final bgAudioNotifier = providerContainer.read(backgroundAudioHandlerProvider.notifier);
  WidgetsBinding.instance.addObserver(AppLifecycleHandler(bgAudioNotifier));
  runApp(
    UncontrolledProviderScope(
      container: providerContainer,
      child: const AppUI(),
    ),
  );
}
