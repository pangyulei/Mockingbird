// import 'package:mockingbird/db/db.dart';
// import 'package:mockingbird/db/entities/metadata_entity.dart';
// import 'package:riverpod_annotation/riverpod_annotation.dart';

// part 'db_metadata_provider.g.dart';

// @Riverpod(name: 'dbMetadataProvider', keepAlive: true)
// class DBMetadata extends _$DBMetadata {
//   @override
//   Future<MetadataEntity> build() async {
//     return await DB().loadMetadata();
//   }

//   Future<void> setPlayingMediaId(String id) async {
//     final pref = await future;
//     if (pref.playingMediaId != id) {
//       await _updateMetadata((pref) => pref.copyWith(playingMediaId: () => id));
//     }
//   }

//   Future<void> setPlayingSubtitleName(String name) async {
//     final pref = await future;
//     if (pref.playingSubtitleName != name) {
//       await _updateMetadata(
//         (pref) => pref.copyWith(playingSubtitleName: () => name),
//       );
//     }
//   }

//   Future<void> setPermissionRequested() async {
//     await _updateMetadata((pref) => pref.copyWith(permissionRequested: true));
//   }

//   Future<void> _updateMetadata(
//     MetadataEntity Function(MetadataEntity metadata) getter,
//   ) async {
//     final metadata = await future;
//     final updatedMetadata = getter(metadata);
//     if (updatedMetadata != metadata) {
//       await DB().updateMetadata(updatedMetadata);
//       state = AsyncData(updatedMetadata);
//     }
//   }
// }
