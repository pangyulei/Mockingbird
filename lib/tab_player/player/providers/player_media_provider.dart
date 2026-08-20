

//   void _mediaPositionChanged(
//     PlayerMediaControllerITF mediaController,
//     Duration position,
//   ) async {
//     final duration = mediaController.duration;
//     if (position >= duration) {
//       //if video end of duration, play/pause button should update
//       //feature: replay if auto play to end
//       await seek(const Duration(seconds: 0));
//       await play();
//     }
//     //for video slider moving along with playing
//     var data = await future;
//     if (data is PlayerMediaData) {
//       state = AsyncData(data.copyWith(position: position));
//     }
//   }

//   void _listen() {
//     debugPrint('listen added!');
//     _listenToVolume();
//     _listenToSpeed();
//   }

//   void _listenToSpeed() {
//     ref.listen(playerSettingProvider.select((st) => st.speed), (
//       previous,
//       speed,
//     ) async {
//       await state.value?.as<PlayerMediaData>()?.mediaController.setSpeed(speed);
//     });
//   }

//   void _listenToVolume() {
//     ref.listen(playerSettingProvider.select((st) => st.volume), (
//       previous,
//       volume,
//     ) async {
//       await state.value?.as<PlayerMediaData>()?.mediaController.setVolume(
//         volume,
//       );
//     });
//   }

// }
