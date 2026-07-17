import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockingbird/db/entities/en_album.dart';
import 'package:mockingbird/tab_albums/album_card/album_card_provider.dart';
import 'package:mockingbird/tab_albums/album_card/album_card_ui.dart';
import 'package:mockingbird/tab_albums/album_list/album_list_provider.dart';
import 'package:mockingbird/tab_albums/album_list/album_list_state.dart';
import 'package:mockingbird/tab_albums/edit_album/edit_album_provider.dart';
import 'package:mockingbird/tab_albums/edit_album/edit_album_ui.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

abstract interface class AlbumListNotifierITF {
  EnAlbum? albumAtIndex(int i);
}

class AlbumListUI extends ConsumerStatefulWidget {
  final ProviderListenable<AsyncValue<AlbumListState>> _provider;
  final AlbumListNotifierITF _notifier;
  const AlbumListUI(this._provider, this._notifier, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AlbumListUIState();
}

class _AlbumListUIState extends ConsumerState<AlbumListUI> {
  ProviderListenable<AsyncValue<AlbumListState>> get _provider => widget._provider;
  AlbumListNotifierITF get _notifier => widget._notifier;

  @override
  Widget build(BuildContext ctx) {
    return Stack(children: [_page(ctx, ref), _empty()]);
  }

  Widget _empty() {
    return Consumer(
      builder: (ctx, ref, child) {
        final isEmpty = ref.watch(
          _provider.select((s) => s.value?.albumCount == 0),
        );
        if (!isEmpty) {
          return const SizedBox.shrink();
        }
        return Scaffold(
          appBar: _appBar(ctx, ref),
          body: const Center(child: Text('no data, make me mroe beautiful')),
        );
      },
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
                _provider.select((s) => s.value?.albumCount ?? 0),
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

  Widget _grid(WidgetRef ref) {
    final count = ref.watch(_provider.select((s) => s.value?.albumCount ?? 0));
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
        final album = _notifier.albumAtIndex(i);
        final provider = albumCardProvider(album?.id);
        final notifier = ref.read(provider.notifier);
        return AlbumCardUI(provider, notifier);
      },
    );
  }

  Future<void> _showAddAlbumDialog(BuildContext ctx) async {
    await showDialog(
      context: ctx,
      builder: (context) {
        return Consumer(
          builder: (context, ref, child) {
            final provider = editAlbumProvider(null);
            final notifier = ref.read(provider.notifier);
            return EditAlbumUI(provider, notifier);
          },
        );
      },
    );
  }

  void _onAddAlbum(BuildContext ctx) async {
    await _showAddAlbumDialog(ctx);
  }
}
