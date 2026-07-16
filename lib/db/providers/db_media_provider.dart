// import 'package:collection/collection.dart';
// import 'package:mockingbird/db/db_logic.dart';
// import 'package:mockingbird/db/entities/en_media.dart';
// import 'package:mockingbird/db/entities/en_subtitle.dart';
// import 'package:mockingbird/db/providers/db_album_provider.dart';
// import 'package:mockingbird/db/providers/db_pref_provider.dart';
// import 'package:riverpod_annotation/riverpod_annotation.dart';

// part 'db_media_provider.g.dart';

// @Riverpod(name: 'dbMediaProvider')
// class DBMedia extends _$DBMedia {
//   @override
//   Future<EnMedia?> build(int id) async {
//     return await DBLogic().loadMedia(id);
//   }

//   Future<void> delete() async {
//     final media = await future;
//     if (media == null) return;
//     await DBLogic().deleteMedia(media);
//     ref.invalidateSelf();
//     final albumId = media.albums.firstOrNull?.id;
//     if (albumId != null) {
//       ref.invalidate(dbAlbumProvider(albumId));
//     }
//     ref.invalidate(dbPrefProvider);
//   }

//   Future<void> addSubtitle(EnSubtitle subtitle) async {
//     final media = await future;
//     if (media == null) return;
//     final albumId = media.albums.firstOrNull?.id;
//     if (albumId == null) return;
//     await DBLogic().addSubtitle(media, subtitle);
//     // await ref.read(dbAlbumProvider(albumId).notifier).updateByMediaUpdated();
//     ref.invalidateSelf();
//   }

//   Future<void> deleteSubtitle() async {
//     final media = await future;
//     if (media == null) return;
//     final albumId = media.albums.firstOrNull?.id;
//     if (albumId == null) return;
//     await DBLogic().deleteSubtitle(media);
//     // await ref.read(dbAlbumProvider(albumId).notifier).updateByMediaUpdated();
//     ref.invalidateSelf();
//   }
// }
