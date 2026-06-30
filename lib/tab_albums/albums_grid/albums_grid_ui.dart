import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mockingbird/model/album.dart';
import 'package:mockingbird/tab_albums/album_card/album_card_state.dart';
import 'package:mockingbird/tab_albums/album_card/album_card_ui.dart';
import 'package:mockingbird/tab_albums/album_edit/ui_album_edit.dart';
import 'package:mockingbird/tab_albums/album_edit/ui_album_edit_snapshot_provider.dart';
import 'package:mockingbird/tab_albums/albums_grid/albums_grid_state.dart';

abstract interface class AlbumsGridUIOutputITF implements AlbumCardUIOutputITF {
  void albumsGrid_onAddAlbum();
}

class AlbumsGridUI extends StatelessWidget {
  final AlbumsGridUIOutputITF _logic;
  final AlbumsGridState _state;
  const AlbumsGridUI(this._state, this._logic, {super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(appBar: _appBar(context), body: _grid()),
        if (_state.showLoading) _loading(),
      ],
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Albums'),
          Text(
            '${_state.albumsCount} created albums',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
        ],
      ),
      centerTitle: false,
      actions: [
        IconButton(
          onPressed: _logic.albumsGrid_onAddAlbum,
          iconSize: 34,
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }

  Widget _loading() {
    return ColoredBox(
      color: Colors.black.withAlpha(50),
      child: const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _grid() {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: _state.albumStates.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        final albumState = _state.albumStates[index].copyWith(index: index);
        return AlbumCardUI(albumState, _logic);
      },
    );
  }
}

