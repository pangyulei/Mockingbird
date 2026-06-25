import 'dart:async';

import 'package:mockingbird/db/db_album.dart';
import 'package:mockingbird/db/db_objectbox.dart';
import 'package:mockingbird/model/album.dart';
import 'package:mockingbird/tab_albums/album_card/ui_album_card_events.dart';
import 'package:mockingbird/tab_albums/album_card/ui_album_card_snapshot.dart';
import 'package:mockingbird/tab_albums/albums_grid/ui_albums_grid_snapshot.dart';
import 'package:mockingbird/tab_albums/albums_grid/ui_albums_grid_snapshot_provider_itf.dart';
import 'package:mockingbird/tool/global_broadcaster.dart';

class UIAlbumsGridSnapshotProvider implements UIAlbumsGridSnapshotProviderITF {
  @override
  final snapshot = UIAlbumsGridSnapshot();
  final _subscriptions = <StreamSubscription>[];
  var _albums = <Album>[];

  UIAlbumsGridSnapshotProvider() {
    _subscriptions.addAll([
      Broadcaster().on<UIAlbumsCardEventOnEdit>(_albumsGridOnEditAlbum),
      Broadcaster().on<UIAlbumsCardEventOnDelete>(_albumsGridOnDeleteAlbum),
      Broadcaster().on<UIAlbumsCardEventOnTap>(_albumsGridOnTapAlbum),
    ]);
  }

  void _albumsGridOnEditAlbum(UIAlbumsCardEventOnEdit event) {}

  void _albumsGridOnDeleteAlbum(UIAlbumsCardEventOnDelete event) {}

  void _albumsGridOnTapAlbum(UIAlbumsCardEventOnTap event) {}

  @override
  bool albumsGridAcceptDragAndDrop(
    UIAlbumCardSnapshot drag,
    UIAlbumCardSnapshot drop,
  ) {
    return _albums[drag.index].id != _albums[drop.index].id;
  }

  @override
  void albumsGridDragAndDrop(
    UIAlbumCardSnapshot drag,
    UIAlbumCardSnapshot drop,
  ) async {
    // await _swapAlbums(draggedAlbum, targetAlbum);
  }

  // Future<void> _swapAlbums(Album draggedAlbum, Album targetAlbum) async {
  //   setState(() {
  //     _showLoading = true;
  //   });
  //   int fromIndex = _albums.indexOf(draggedAlbum);
  //   int toIndex = _albums.indexOf(targetAlbum);
  //   //swap db sortorder first, then swap their place in List
  //   (draggedAlbum, targetAlbum) = await DBAlbum(
  //     DBObjectBox.instance.store,
  //   ).swapSortOrder(draggedAlbum, targetAlbum);
  //   setState(() {
  //     _albums[fromIndex] = targetAlbum;
  //     _albums[toIndex] = draggedAlbum;
  //     _showLoading = false;
  //   });
  // }

  @override
  void albumsGridDispose() {
    snapshot.dispose();
  }

  @override
  void albumsGridInitState() async {
    // snapshot.showLoading.value = true;
    // 执行数据库查询
    _albums = await DBAlbum(DBObjectBox().store).getAll();
    snapshot.albumCardSnapshots.value = _albums.map((a) {
      final albumCardSnapshot = UIAlbumCardSnapshot();
      albumCardSnapshot.cover.value = a.cover;
      albumCardSnapshot.name.value = a.name;
      albumCardSnapshot.mediasCount.value = a.medias.length;
      return albumCardSnapshot;
    }).toList();
    // snapshot.showLoading.value = false;
  }

  @override
  void albumsGridOnAddAlbum() {
    snapshot.showUIAlbumEdit.value = true;
  }

  // void _onTapAlbum(Album album) {
  //   Navigator.pushNamed(context, RouteAlbums.albumDetail(album.id));
  // }

  // Future<void> _onEditAlbum(Album album) async {
  //   await showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlbumEdit(
  //         name: album.name,
  //         cover: album.cover != null ? File(album.cover!) : null,
  //         title: 'Edit Album',
  //         submitTitle: 'Save',
  //         onSubmit: (name, cover) async {
  //           bool isIdentical() {
  //             if (name.trim() != album.name) return false;
  //             if (cover == null && album.cover == null) return true;
  //             return cover != null &&
  //                 album.cover != null &&
  //                 cover.path == album.cover;
  //           }

  //           if (!isIdentical()) {
  //             setState(() {
  //               _showLoading = true;
  //             });
  //             final updatedAlbum = await DBAlbum(
  //               DBObjectBox.instance.store,
  //             ).update(album: album, name: name, cover: cover);
  //             setState(() {
  //               int index = _albums.indexOf(album);
  //               _albums[index] = updatedAlbum;
  //               _showLoading = false;
  //             });
  //           }
  //         },
  //       );
  //     },
  //   );
  // }

  // Future<void> _onDeleteAlbum(Album album) async {
  //   final confirmed = await showDialog<bool>(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: const Text('Delete Album'),
  //       content: Text(
  //         'Are you sure you want to delete "${album.name}"? This action cannot be undone.',
  //       ),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.pop(context, false),
  //           child: const Text('Cancel'),
  //         ),
  //         FilledButton(
  //           onPressed: () => Navigator.pop(context, true),
  //           style: FilledButton.styleFrom(
  //             backgroundColor: Theme.of(context).colorScheme.error,
  //           ),
  //           child: const Text('Delete'),
  //         ),
  //       ],
  //     ),
  //   );

  //   if (confirmed == null || !confirmed) {
  //     return;
  //   }

  //   setState(() {
  //     _showLoading = true;
  //   });

  //   // Remove from database
  //   await DBAlbum(DBObjectBox.instance.store).remove(album);

  //   // Update state with remaining albums
  //   setState(() {
  //     _albums.remove(album);
  //     _showLoading = false;
  //   });
  // }
}
