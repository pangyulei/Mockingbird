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
  bool get mb_isPlaying;
  bool get mb_isBuffering;
  Duration get mb_position;
  Duration get mb_duration;
  double get mb_speed;
  double? get mb_ratio;
  String? get mb_path;
  FutureOr<void> mb_dispose();
  void mb_listenPosition(
    void Function(PlayerMediaControllerITF mediaController, Duration position)
    listener,
  );
  void mb_listenPlaying(
    void Function(PlayerMediaControllerITF mediaController, bool isPlaying)
    listener,
  );
  void mb_listenDuration(
    void Function(PlayerMediaControllerITF mediaController, Duration duration)
    listener,
  );
  void mb_listenBuffering(
    void Function(PlayerMediaControllerITF mediaController, bool isBuffering)
    listener,
  );
  Widget get mb_mediaPlayer;
}

class PlayerMediaController implements PlayerMediaControllerITF {
  final _player = Player();
  String? _path;
  final _subs = <StreamSubscription>[];
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
    //outside is 0-1, but Player's volume is 0-100
    await _player.setVolume(volume * 100);
  }

  @override
  bool get mb_isPlaying => _player.state.playing;

  @override
  bool get mb_isBuffering => _player.state.buffering;

  @override
  Duration get mb_duration => _player.state.duration;

  @override
  double get mb_speed => _player.state.rate;

  @override
  Duration get mb_position => _player.state.position;

  @override
  Widget get mb_mediaPlayer => Video(
    controller: VideoController(_player),
    pauseUponEnteringBackgroundMode: false,
    resumeUponEnteringForegroundMode: true,
  );

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
    for (final sub in _subs) {
      sub.cancel();
    }
    await _player.dispose();
  }

  @override
  void mb_listenPosition(
    void Function(PlayerMediaControllerITF mediaController, Duration position)
    listener,
  ) {
    final sub = _player.stream.position.listen((position) {
      listener(this, position);
    });
    _subs.add(sub);
  }

  @override
  void mb_listenPlaying(
    void Function(PlayerMediaControllerITF mediaController, bool isPlaying)
    listener,
  ) {
    final sub = _player.stream.playing.listen((isPlaying) {
      listener(this, isPlaying);
    });
    _subs.add(sub);
  }

  @override
  void mb_listenDuration(
    void Function(PlayerMediaControllerITF mediaController, Duration duration)
    listener,
  ) {
    final sub = _player.stream.duration.listen((duration) {
      listener(this, duration);
    });
    _subs.add(sub);
  }

  @override
  void mb_listenBuffering(
    void Function(PlayerMediaControllerITF mediaController, bool isBuffering)
    listener,
  ) {
    final sub = _player.stream.buffering.listen((isBuffering) {
      listener(this, isBuffering);
    });
    _subs.add(sub);
  }
}
