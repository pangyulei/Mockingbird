// import 'dart:async';

// import 'package:flutter/cupertino.dart';
// import 'package:media_kit/media_kit.dart';
// import 'package:media_kit_video/media_kit_video.dart';
// import 'package:photo_manager/photo_manager.dart';


// class PlayerMediaController {
//   AssetEntity? _media;
//   PlayerMediaController();



//   @override
//   double get ratio {
//     final width = _player.state.width?.toDouble();
//     final height = _player.state.height?.toDouble();
//     if (width != null && height != null && height != 0) {
//       debugPrint('media ratio $width/$height');
//       return width / height;
//     } else {
//       return 1;
//     }
//   }

//   @override
//   AssetType get type => _media?.type ?? AssetType.video;

//   @override
//   FutureOr<void> open(AssetEntity asset) async {
//     _media = asset;
//     final path = (await asset.file)?.path;
//     if (path != null) {
//       await _player.open(Media(path));
//     }
//   }

//   @override
//   bool get completed => _player.state.completed;

//   @override
//   StreamSubscription listenPosition(
//     void Function(PlayerMediaControllerITF mediaController, Duration position)
//     listener,
//   ) {
//     return _player.stream.position.listen((position) {
//       listener(this, position);
//     });
//   }
//   @override
//   StreamSubscription listenDuration(
//     void Function(PlayerMediaControllerITF mediaController, Duration duration)
//     listener,
//   ) {
//     return _player.stream.duration.listen((duration) {
//       listener(this, duration);
//     });
//   }

// }
