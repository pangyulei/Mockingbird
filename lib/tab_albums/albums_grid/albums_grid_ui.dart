import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mockingbird/model/album.dart';
import 'package:mockingbird/tab_albums/album_card/album_card_state.dart';
import 'package:mockingbird/tab_albums/album_card/album_card_ui.dart';
import 'package:mockingbird/tab_albums/album_edit/ui_album_edit.dart';
import 'package:mockingbird/tab_albums/album_edit/ui_album_edit_snapshot_provider.dart';
import 'package:mockingbird/tab_albums/albums_grid/albums_grid_state.dart';

abstract interface class AlbumsGridUIOutputITF {
  void albumsGrid_initState();
  void albumsGrid_dispose();
  void albumsGrid_onAddAlbum();
  void albumsGrid_onDeleteAlbum(AlbumsGridStateGeneral state, int index);
  void albumsGrid_onEditAlbum(int index);
  void albumsGrid_onTapAlbum(int index);
}

abstract interface class AlbumsGridUIInputITF {
  void handleNewState(AlbumsGridState newState);
}

abstract interface class AlbumsGridLogicITF implements AlbumsGridUIOutputITF {
  set output(AlbumsGridUIInputITF output);
}

class AlbumsGridUI extends StatefulWidget {
  final AlbumsGridLogicITF _logic;
  const AlbumsGridUI(this._logic, {super.key});

  @override
  State<AlbumsGridUI> createState() => _AlbumGridUIState();
}

class _AlbumGridUIState extends State<AlbumsGridUI>
    implements AlbumsGridUIInputITF, AlbumCardLogicITF {
  AlbumsGridState _state = const AlbumsGridStateGeneral(
    albumStates: [],
    albumsCount: 0,
    showLoading: false,
  );

  @override
  void initState() {
    super.initState();
    widget._logic.output = this;
    widget._logic.albumsGrid_initState();
  }

  @override
  void dispose() {
    widget._logic.albumsGrid_dispose();
    super.dispose();
  }

  @override
  void handleNewState(AlbumsGridState newState) {
    switch (newState) {
      case AlbumsGridStateCreatingAlbum():
        _state = newState;
        _showCreatingAlbumDialog();
      case AlbumsGridStateEditingAlbum(:final album):
        _state = newState;
        _showEditingAlbumDialog(album);
      case AlbumsGridStateGeneral():
        setState(() {
          _state = newState;
        });
    }
  }

  Future<void> _showCreatingAlbumDialog() async {
    await showDialog(
      context: context,
      builder: (context) {
        return UIAlbumEdit(
          title: 'Create New Album',
          provider: UIAlbumEditSnapshotProvider(null),
          submitTitle: 'Create',
        );
      },
    );
  }

  Future<void> _showEditingAlbumDialog(Album album) async {
    await showDialog(
      context: context,
      builder: (context) {
        return UIAlbumEdit(
          title: 'Edit Album',
          provider: UIAlbumEditSnapshotProvider(album),
          submitTitle: 'Save',
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (_state) {
      case AlbumsGridStateGeneral(
        :final albumStates,
        :final albumsCount,
        :final showLoading,
      ):
        return Stack(
          children: [
            Scaffold(appBar: _appBar(albumsCount), body: _grid(albumStates)),
            if (showLoading) _loading(),
          ],
        );
      case _:
        return const Scaffold();
    }
  }

  AppBar _appBar(int albumsCount) {
    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Albums'),
          Text(
            '$albumsCount created albums',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
        ],
      ),
      centerTitle: false,
      actions: [
        IconButton(
          onPressed: widget._logic.albumsGrid_onAddAlbum,
          iconSize: 34,
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }

  Widget _loading() {
    return ColoredBox(
      color: Colors.black.withAlpha(50),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _grid(List<AlbumCardState> albumStates) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: albumStates.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        final albumState = albumStates[index].copyWith(index: index);
        return AlbumCardUI(logic: this, state: albumState);
      },
    );
  }

  @override
  void albumCard_onDelete(int index) {
    if (_state is AlbumsGridStateGeneral) {
      widget._logic.albumsGrid_onDeleteAlbum(
        _state as AlbumsGridStateGeneral,
        index,
      );
    } else {
      assert(false, 'should only on general state can tap delete button');
    }
  }

  @override
  void albumCard_onEdit(int index) {
    widget._logic.albumsGrid_onEditAlbum(index);
  }

  @override
  void albumCard_onTap(int index) {
    widget._logic.albumsGrid_onTapAlbum(index);
  }
}
