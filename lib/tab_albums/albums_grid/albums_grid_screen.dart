import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mockingbird/db/db_album.dart';
import 'package:mockingbird/db/db_objectbox.dart';
import 'package:mockingbird/model/album.dart';
import 'package:mockingbird/tab_albums/album_card/album_card_state.dart';
import 'package:mockingbird/tab_albums/album_edit/album_edit_screen.dart';
import 'package:mockingbird/tab_albums/albums_grid/albums_grid_state.dart';
import 'package:mockingbird/tab_albums/albums_grid/albums_grid_ui.dart';

class AlbumsGridScreen extends StatefulWidget {
  const AlbumsGridScreen({super.key});

  @override
  State<StatefulWidget> createState() => _AlbumsGridScreenState();
}

class _AlbumsGridScreenState extends State<AlbumsGridScreen>
    implements AlbumsGridUIOutputITF {
  var _state = const AlbumsGridState.empty();
  var _albums = <Album>[];
  final _subs = <StreamSubscription>[];

  @override
  void initState() {
    super.initState();
    _observeAlbums();
  }

  void _observeAlbums() {
    _state = _state.copyWith(showLoading: true);
    //observe Album DB
    final albumsStream = DBObjectBox().store
        .box<Album>()
        .query()
        .watch(triggerImmediately: true)
        .map((q) async => await q.findAsync());
    final sub = albumsStream.listen((event) async {
      _albums = await event;
      final albumStates = _albums.map((a) {
        return AlbumCardState(
          index: 0,
          mediasCount: a.medias.length,
          name: a.name,
          cover: a.cover,
        );
      }).toList();
      setState(() {
        _state = _state.copyWith(
          showLoading: false,
          albumStates: albumStates,
          albumsCount: _albums.length,
        );
      });
    });
    _subs.add(sub);
  }

  @override
  void dispose() {
    _cancelAllSubs();
    super.dispose();
  }

  void _cancelAllSubs() {
    for (final sub in _subs) {
      sub.cancel();
    }
  }

  Future<void> _showCreatingAlbumDialog() async {
    await showDialog(
      context: context,
      builder: (context) {
        return const AlbumEditScreen(null);
      },
    );
  }

  Future<void> _showEditingAlbumDialog(Album album) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlbumEditScreen(album);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlbumsGridUI(_state, this);
  }

  @override
  void albumsGrid_onAddAlbum() async {
    await _showCreatingAlbumDialog();
  }

  @override
  void albumCard_onDelete(int index) async {
    Album album = _albums[index];
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Album'),
        content: Text(
          'Are you sure you want to delete "${album.name}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == null || !confirmed) {
      return;
    }

    setState(() {
      _state = _state.copyWith(showLoading: true);
    });
    await DBAlbum(DBObjectBox().store).remove(album);
  }

  @override
  void albumCard_onEdit(int index) async {
    Album album = _albums[index];
    await _showEditingAlbumDialog(album);
  }

  @override
  void albumCard_onTap(int index) {
    // TODO: implement albumCard_onTap
  }
}
