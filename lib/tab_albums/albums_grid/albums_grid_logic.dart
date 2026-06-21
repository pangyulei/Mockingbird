// import 'dart:io';
//
// import 'package:mockingbird/db/db_album.dart';
// import 'package:mockingbird/db/db_objectbox.dart';
// import 'package:mockingbird/model/album.dart';
// import 'album_card/album_card_state.dart';
// import 'albums_grid_interface_ui_events.dart';
// import 'albums_grid_state.dart';
//
//
// class AlbumsGridLogic implements AlbumsGridInterfaceUIEvents {
//   const AlbumsGridLogic();


//
//   @override
//   Stream<AlbumsGridState> albumsGridPoppedEditWidget(
//     AlbumsGridState state,
//     Album album,
//     ({String name, File? coverFile})? updatedAlbumInfo,
//   ) async* {
//     if (updatedAlbumInfo == null) {
//       yield state;
//     } else {
//       yield state.copyWith(showLoading: true);
//
//       final updatedAlbum = await DBAlbum(DBObjectBox.instance.store).update(
//         album: album,
//         newName: updatedAlbumInfo._name,
//         newCover: updatedAlbumInfo.coverFile,
//         removeCover: updatedAlbumInfo.coverFile == null,
//       );
//
//       final newAlbums = state.albumStates.map((a) {
//         return a.id == updatedAlbum.id ? updatedAlbum : a;
//       }).toList();
//
//       yield state.copyWith(albumStates: newAlbums, showLoading: false);
//     }
//   }
//
//   @override
//   Stream<AlbumsGridState> albumsGridRemoveAlbum(
//     AlbumsGridState state,
//     Album album,
//   ) async* {
//     yield state.copyWith(showLoading: true);
//
//     // Remove from database
//     await DBAlbum(DBObjectBox.instance.store).remove(album);
//
//     // Update state with remaining albums
//     final remainingAlbums = state.albumStates
//         .where((p) => p.id != album.id)
//         .toList();
//
//     yield state.copyWith(
//       albumStates: remainingAlbums,
//       showLoading: false,
//     );
//   }
// }
