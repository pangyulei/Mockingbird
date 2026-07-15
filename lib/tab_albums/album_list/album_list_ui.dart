import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockingbird/tab_albums/album_card/album_card_provider.dart';
import 'package:mockingbird/tab_albums/album_card/album_card_ui.dart';
import 'package:mockingbird/tab_albums/album_list/album_list_provider.dart';
import 'package:mockingbird/tab_albums/edit_album/edit_album_ui.dart';

class AlbumListUI extends ConsumerWidget {
  const AlbumListUI({super.key});

  @override
  Widget build(BuildContext ctx, WidgetRef ref) {
    return Stack(children: [_page(ctx, ref), _empty(ctx, ref), _loading(ref)]);
  }

  Widget _empty(BuildContext ctx, WidgetRef ref) {
    final isEmpty = ref.watch(
      albumListProvider.select((s) => s.value?.albumCount == 0),
    );
    if (!isEmpty) {
      return const SizedBox.shrink();
    }
    return Scaffold(
      appBar: _appBar(ctx, ref),
      body: const Center(child: Text('no data, make me mroe beautiful')),
    );
  }

  Widget _page(BuildContext ctx, WidgetRef ref) {
    return Scaffold(appBar: _appBar(ctx, ref), body: _grid(ref));
  }

  AppBar _appBar(BuildContext ctx, WidgetRef ref) {
    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Albums'),
          Consumer(
            builder: (context, ref, child) {
              final count = ref.watch(
                albumListProvider.select((s) => s.value?.albumCount ?? 0),
              );
              return Text(
                '$count created albums',
                style: Theme.of(ctx).textTheme.bodySmall?.copyWith(
                  color: Theme.of(ctx).colorScheme.outline,
                ),
              );
            },
          ),
        ],
      ),
      centerTitle: false,
      actions: [
        IconButton(
          onPressed: () => _onAddAlbum(ctx),
          iconSize: 34,
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }

  Widget _loading(WidgetRef ref) {
    final isLoading = ref.watch(albumListProvider).isLoading;
    if (!isLoading) {
      return const SizedBox.shrink();
    }
    return Container(
      color: Colors.black54,
      child: const Center(child: CircularProgressIndicator(strokeWidth: 3)),
    );
  }

  Widget _grid(WidgetRef ref) {
    final count = ref.watch(albumListProvider).value?.albumCount ?? 0;
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: count,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        childAspectRatio: 1,
      ),
      itemBuilder: (ctx, i) {
        final albumId = ref.read(albumListProvider.notifier).albumIdAtIndex(i);
        final provider = albumCardProvider(albumId);
        final notifier = ref.read(provider.notifier);
        return AlbumCardUI(provider, notifier);
      },
    );
  }

  Future<void> _showCreatingAlbumDialog(BuildContext ctx) async {
    await showDialog(
      context: ctx,
      builder: (context) {
        return const EditAlbumUI(null);
      },
    );
  }

  void _onAddAlbum(BuildContext ctx) async {
    await _showCreatingAlbumDialog(ctx);
  }
}
