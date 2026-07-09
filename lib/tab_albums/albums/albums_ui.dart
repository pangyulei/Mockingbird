import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockingbird/tab_albums/album_card/album_card_state.dart';
import 'package:mockingbird/tab_albums/album_card/album_card_ui.dart';
import 'package:mockingbird/tab_albums/albums/albums_provider.dart';

abstract interface class AlbumsUIOutputITF implements AlbumCardUIOutputITF {
  void albumsGrid_onAddAlbum();
}

class AlbumsUI extends ConsumerWidget {
  final AlbumsUIOutputITF _logic;
  const AlbumsUI(this._logic, {super.key});

  @override
  Widget build(BuildContext ctx, WidgetRef ref) {
    final av = ref.watch(albumsProvider);
    return Stack(
      children: [
        av.hasValue && av.requireValue.states.isNotEmpty
            ? _page(ctx, av.requireValue.states)
            : _empty(ctx),
        if (av.isLoading || (av.value?.isLoading ?? false)) _loading(),
      ],
    );
  }

  Widget _empty(BuildContext ctx) {
    return Scaffold(
      appBar: _appBar(ctx, 0),
      body: const Center(child: Text('no data, make me mroe beautiful')),
    );
  }

  Widget _page(BuildContext ctx, List<AlbumCardState> states) {
    return Scaffold(appBar: _appBar(ctx, states.length), body: _grid(states));
  }

  AppBar _appBar(BuildContext ctx, int count) {
    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Albums'),
          Text(
            '$count created albums',
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
    return Container(
      color: Colors.black54,
      child: const Center(child: CircularProgressIndicator(strokeWidth: 3)),
    );
  }

  Widget _grid(List<AlbumCardState> states) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: states.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        childAspectRatio: 1,
      ),
      itemBuilder: (ctx, index) {
        final state = states[index];
        return AlbumCardUI(index, state, _logic);
      },
    );
  }
}
