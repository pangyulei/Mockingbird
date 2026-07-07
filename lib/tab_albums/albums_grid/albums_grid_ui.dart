import 'package:flutter/material.dart';
import 'package:mockingbird/tab_albums/album_card/album_card_ui.dart';
import 'package:mockingbird/tab_albums/albums_grid/albums_grid_state.dart';

abstract interface class AlbumsGridUIOutputITF implements AlbumCardUIOutputITF {
  void albumsGrid_onAddAlbum();
}

class AlbumsGridUI extends StatelessWidget {
  final AlbumsGridUIOutputITF _logic;
  final AlbumsGridState _state;
  const AlbumsGridUI(this._state, this._logic, {super.key});

  @override
  Widget build(BuildContext ctx) {
    return Stack(children: [_page(ctx), if (_state.showLoading) _loading()]);
  }

  Widget _page(BuildContext ctx) {
    return Scaffold(appBar: _appBar(ctx), body: _grid());
  }

  AppBar _appBar(BuildContext ctx) {
    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Albums'),
          Text(
            '${_state.albumsCount} created albums',
            style: Theme.of(ctx).textTheme.bodySmall?.copyWith(
              color: Theme.of(ctx).colorScheme.outline,
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
      color: Colors.black.withAlpha(20),
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
      itemBuilder: (ctx, index) {
        final albumState = _state.albumStates[index].copyWith(index: index);
        return AlbumCardUI(index, albumState, _logic);
      },
    );
  }
}
