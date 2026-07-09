import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mockingbird/app/app_route.dart';
import 'package:mockingbird/db/db_logic.dart';
import 'package:mockingbird/db/db_objectbox.dart';
import 'package:mockingbird/db/entities/album.dart';
import 'package:mockingbird/tab_albums/album_card/album_card_state.dart';
import 'package:mockingbird/tab_albums/albums/albums_ui.dart';
import 'package:mockingbird/tab_albums/edit_album/edit_album_screen.dart';

class AlbumsScreen extends StatefulWidget {
  const AlbumsScreen({super.key});

  @override
  State<StatefulWidget> createState() => _AlbumsScreenState();
}

class _AlbumsScreenState extends State<AlbumsScreen>
    implements AlbumsUIOutputITF {
  // var _albums = <Album>[];
  // final _subs = <StreamSubscription>[];

  // @override
  // void initState() {
  //   super.initState();
  //   _observeAlbums();
  // }

  // void _observeAlbums() {
  //   _state = _state.copyWith(showLoading: true);
  //   //observe Album DB
  //   final albumsStream = DBObjectBox().store
  //       .box<Album>()
  //       .query()
  //       .watch(triggerImmediately: true)
  //       .map((q) async => await q.findAsync());
  //   final sub = albumsStream.listen((event) async {
  //     _albums = await event;
  //     final albumStates = _albums.map((a) => a.toCardState()).toList();
  //     setState(() {
  //       _state = _state.copyWith(
  //         showLoading: false,
  //         albumStates: albumStates,
  //         albumsCount: _albums.length,
  //       );
  //     });
  //   });
  //   _subs.add(sub);
  // }

  // @override
  // void dispose() {
  //   _cancelAllSubs();
  //   super.dispose();
  // }

  // void _cancelAllSubs() {
  //   for (final sub in _subs) {
  //     sub.cancel();
  //   }
  // }

  Future<void> _showCreatingAlbumDialog() async {
    await showDialog(
      context: context,
      builder: (context) {
        return const EditAlbumScreen(null);
      },
    );
  }

  Future<void> _showEditingAlbumDialog(int id) async {
    await showDialog(
      context: context,
      builder: (context) {
        return EditAlbumScreen(id);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlbumsUI(this);
  }

  @override
  void albumsGrid_onAddAlbum() async {
    await _showCreatingAlbumDialog();
  }

  @override
  void albumCard_onDelete(int index) async {
    // Album album = _albums[index];
    // final confirmed = await showDialog<bool>(
    //   context: context,
    //   builder: (context) => AlertDialog(
    //     title: const Text('Delete Album'),
    //     content: Text(
    //       'Are you sure you want to delete "${album.name}"? This action cannot be undone.',
    //     ),
    //     actions: [
    //       TextButton(
    //         onPressed: () => Navigator.pop(context, false),
    //         child: const Text('Cancel'),
    //       ),
    //       FilledButton(
    //         onPressed: () => Navigator.pop(context, true),
    //         style: FilledButton.styleFrom(
    //           backgroundColor: Theme.of(context).colorScheme.error,
    //         ),
    //         child: const Text('Delete'),
    //       ),
    //     ],
    //   ),
    // );

    // if (confirmed == null || !confirmed) {
    //   return;
    // }

    // setState(() {
    //   _state = _state.copyWith(showLoading: true);
    // });
    // await DBLogic().deleteAlbum(album);
  }

  @override
  void albumCard_onEdit(int index) async {
    // await _showEditingAlbumDialog(_albums[index]);
  }

  @override
  void albumCard_onTap(int index) {
    // context.go(AppRoute.albumById(_albums[index].id));
  }
}
