import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

abstract interface class PlayerMediaControllerITF {
  FutureOr<void> mb_pause();
  FutureOr<void> mb_play();
  FutureOr<void> mb_setSpeed(double speed);
  FutureOr<void> mb_setVolume(double volume);
  FutureOr<void> mb_seek(Duration position);
  FutureOr<void> mb_open(String path);
  Duration get mb_position;
  Duration get mb_duration;
  double? get mb_ratio;
  String? get mb_path;
  FutureOr<void> mb_dispose();
  StreamSubscription mb_addListener(
    void Function(PlayerMediaControllerITF mediaController, Duration position)
    listener,
  );
  Widget get mb_mediaPlayer;
}

class PlayerMediaController implements PlayerMediaControllerITF {
  final _player = Player();
  String? _path;
  PlayerMediaController();

  @override
  FutureOr<void> mb_pause() async {
    await _player.pause();
  }

  @override
  FutureOr<void> mb_play() async {
    await _player.play();
  }

  @override
  FutureOr<void> mb_seek(Duration position) async {
    await _player.seek(position);
  }

  @override
  FutureOr<void> mb_setSpeed(double speed) async {
    await _player.setRate(speed);
  }

  @override
  FutureOr<void> mb_setVolume(double volume) async {
    await _player.setVolume(volume);
  }

  @override
  StreamSubscription mb_addListener(
    void Function(PlayerMediaControllerITF mediaController, Duration position)
    listener,
  ) {
    return _player.stream.position.listen((position) {
      listener(this, position);
    });
  }

  @override
  Duration get mb_duration => _player.state.duration;

  @override
  Duration get mb_position => _player.state.position;

  @override
  Widget get mb_mediaPlayer =>
      Video(controller: VideoController(_player), fit: BoxFit.fitHeight);

  @override
  double? get mb_ratio {
    final width = _player.state.width?.toDouble();
    final height = _player.state.height?.toDouble();
    if (width != null && height != null && height != 0) {
      return width / height;
    } else {
      return null;
    }
  }

  @override
  String? get mb_path => _path;

  @override
  FutureOr<void> mb_open(String path) async {
    _path = path;
    await _player.open(Media(path));
  }

  @override
  FutureOr<void> mb_dispose() async {
    await _player.dispose();
  }
}
