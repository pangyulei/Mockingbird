// import 'dart:async';

// import 'package:mockingbird/db/db_album.dart';
// import 'package:mockingbird/db/db_objectbox.dart';
// import 'package:mockingbird/model/album.dart';
// import 'package:mockingbird/tab_albums/album_card/album_card_state.dart';
// import 'package:mockingbird/tab_albums/album_card/ui_album_card_events.dart';
// import 'package:mockingbird/tab_albums/album_edit/ui_album_edit_events.dart';
// import 'package:mockingbird/tab_albums/albums_grid/albums_grid_state.dart';
// import 'package:mockingbird/tab_albums/albums_grid/ui_albums_grid_snapshot_provider_itf.dart';
// import 'package:mockingbird/tool/broadcaster.dart';

// class UIAlbumsGridSnapshotProvider implements UIAlbumsGridSnapshotProviderITF {
 
  


//   void _albumEditDialogOnCancel(UIAlbumEditEventOnCancel event) async {
//     snapshot.showCreatingAlbumDialog.value = false;
//     snapshot.showEditingAlbumDialog.value = null;
//   }

//   void _albumEditDialogOnSubmit(UIAlbumEditEventOnSubmit event) async {
//     final dbAlbum = DBAlbum(DBObjectBox().store);
//     final Album? album = event.album;
//     if (album == null) {
//       //creating
//       snapshot.showCreatingAlbumDialog.value = false;
//       snapshot.showLoading.value = true;
//       await dbAlbum.create(name: event.name, cover: event.cover);
//       snapshot.showLoading.value = false;
//     } else {
//       //editing
//       snapshot.showEditingAlbumDialog.value = null;
//       snapshot.showLoading.value = true;
//       await dbAlbum.update(
//         album: album,
//         name: event.name,
//         coverFunc: () => event.cover,
//       );
//       snapshot.showLoading.value = false;
//     }
//   }




//   @override
//   bool albumsGridAcceptDragAndDrop(AlbumCardState drag, AlbumCardState drop) {
//     return _albums[drag.index].id != _albums[drop.index].id;
//   }

//   @override
//   void albumsGridDragAndDrop(AlbumCardState drag, AlbumCardState drop) async {
//     // await _swapAlbums(draggedAlbum, targetAlbum);
//   }

//   // Future<void> _swapAlbums(Album draggedAlbum, Album targetAlbum) async {
//   //   setState(() {
//   //     _showLoading = true;
//   //   });
//   //   int fromIndex = _albums.indexOf(draggedAlbum);
//   //   int toIndex = _albums.indexOf(targetAlbum);
//   //   //swap db sortorder first, then swap their place in List
//   //   (draggedAlbum, targetAlbum) = await DBAlbum(
//   //     DBObjectBox.instance.store,
//   //   ).swapSortOrder(draggedAlbum, targetAlbum);
//   //   setState(() {
//   //     _albums[fromIndex] = targetAlbum;
//   //     _albums[toIndex] = draggedAlbum;
//   //     _showLoading = false;
//   //   });
//   // }




//   // void _onTapAlbum(Album album) {
//   //   Navigator.pushNamed(context, RouteAlbums.albumDetail(album.id));
//   // }

