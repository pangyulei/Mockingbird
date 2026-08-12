import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:photo_manager/photo_manager.dart';

abstract interface class PlayerMediaControllerITF {
  FutureOr<void> pause();
  FutureOr<void> play();
  FutureOr<void> setSpeed(double speed);
  FutureOr<void> setVolume(double volume);
  FutureOr<void> seek(Duration position);
  FutureOr<void> open(AssetEntity asset);
  bool get playing;
  Duration get position;
  bool get completed;
  Duration get duration;
  double get speed;
  double get ratio;
  AssetType get type;
  Widget get video;
  StreamSubscription listenPosition(
    void Function(PlayerMediaControllerITF assetController, Duration position)
    listener,
  );
}

class PlayerMediaController implements PlayerMediaControllerITF {
  AssetEntity? _media;
  final _player = Player();
  PlayerMediaController();

  @override
  FutureOr<void> pause() async {
    await _player.pause();
  }

  @override
  FutureOr<void> play() async {
    await _player.play();
  }

  @override
  FutureOr<void> seek(Duration position) async {
    debugPrint('root seek $position');
    await _player.seek(position);
    debugPrint('completed $completed');
  }

  @override
  FutureOr<void> setSpeed(double speed) async {
    await _player.setRate(speed);
  }

  @override
  FutureOr<void> setVolume(double volume) async {
    //outside is 0-1, but Player's volume is 0-100
    await _player.setVolume(volume * 100);
  }

  @override
  bool get playing => _player.state.playing;

  @override
  Duration get duration => _player.state.duration;

  @override
  double get speed => _player.state.rate;

  @override
  Duration get position => _player.state.position;

  @override
  Widget get video => Video(
    controller: VideoController(_player),
    pauseUponEnteringBackgroundMode: false,
    resumeUponEnteringForegroundMode: true,
  );

  @override
  double get ratio {
    final width = _player.state.width?.toDouble();
    final height = _player.state.height?.toDouble();
    if (width != null && height != null && height != 0) {
      debugPrint('media ratio $width/$height');
      return width / height;
    } else {
      return 1;
    }
  }

  @override
  AssetType get type => _media?.type ?? AssetType.video;

  @override
  FutureOr<void> open(AssetEntity asset) async {
    _media = asset;
    final path = (await asset.file)?.path;
    if (path != null) {
      await _player.open(Media(path));
    }
  }

  @override
  bool get completed => _player.state.completed;

  @override
  StreamSubscription listenPosition(
    void Function(PlayerMediaControllerITF assetController, Duration position)
    listener,
  ) {
    return _player.stream.position.listen((position) {
      listener(this, position);
    });
  }

}
