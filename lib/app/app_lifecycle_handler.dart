import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mockingbird/tab_player/player/providers/background_audio_handler_provider.dart';

class AppLifecycleHandler with WidgetsBindingObserver {
  final BackgroundAudioHandlerNotifier _bgAudioNotifier;
  const AppLifecycleHandler(this._bgAudioNotifier);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    debugPrint('app state: $state');
    //退后台/锁屏 inactive->hidden->pause
    //回前台 pause->hidden->inactive->resumed
    if (state == AppLifecycleState.paused) {
      await _bgAudioNotifier.updateMediaItem();
    }
  }
}
