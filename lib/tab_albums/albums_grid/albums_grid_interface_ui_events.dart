// import 'dart:io';
//
// import 'package:mockingbird/model/album.dart';
// import 'albums_grid_state.dart';
//
// abstract interface class AlbumsGridInterfaceUIEvents {
//   Stream<AlbumsGridState> albumsGridInitState();
//   bool dragTargetWillAccept(
//     AlbumsGridState state,
//     Album targetAlbum,
//     Album draggedAlbum,
//   );
//   Stream<AlbumsGridState> albumsGridDragTargetAccepted(
//     AlbumsGridState state,
//     Album targetAlbum,
//     Album draggedAlbum,
//   );
//   Stream<AlbumsGridState> albumsGridPoppedCreateWidget(
//     AlbumsGridState state,
//     ({String name, File? coverFile})? newAlbumInfo,
//   );
//   Stream<AlbumsGridState> albumsGridPoppedEditWidget(
//     AlbumsGridState state,
//     Album album,
//     ({String name, File? coverFile})? updatedAlbumInfo,
//   );
//   Stream<AlbumsGridState> albumsGridRemoveAlbum(
//     AlbumsGridState state,
//     Album album,
//   );
// }
