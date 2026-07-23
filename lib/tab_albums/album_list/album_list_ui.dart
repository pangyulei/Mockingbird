import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockingbird/tab_albums/album_card/album_card_ui.dart';
import 'package:mockingbird/tab_albums/album_list/album_list_provider.dart';
import 'package:mockingbird/tab_albums/album_list/album_list_state.dart';
import 'package:mockingbird/tab_albums/edit_album/edit_album_ui.dart';

import '../../tool/extensions.dart';

class AlbumListUI extends ConsumerWidget {
  const AlbumListUI({super.key});

  @override
  Widget build(BuildContext ctx, WidgetRef ref) {
    final bool isLoading = ref.read(
      albumListProvider.select((st) => st.isLoading),
    );
    showLoading(isLoading);
    ref.listen(
      albumListProvider.select((st) => st.isLoading),
      (previous, next) => showLoading(next),
    );
    final stateType = ref.watch(
      albumListProvider.select((st) => st.value?.runtimeType),
    );
    switch (stateType) {
      case AlbumListNull:
        //result is null
        return _empty(ctx, ref);
      case AlbumListData:
        //result is data
        return _page(ctx, ref);
      default:
        //Null/null, means its asyncloading without data, initial load situation
        debugPrint('albumlist stateType: $stateType');
        return Scaffold(appBar: _appBar(ctx, ref),);
    }
  }


  Widget _empty(BuildContext ctx, WidgetRef ref) {
    final theme = Theme.of(ctx);
    final colorScheme = theme.colorScheme;
    return Scaffold(
      appBar: _appBar(ctx, ref),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 48),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.collections_bookmark_rounded,
                  size: 80,
                  color: colorScheme.primary.withValues(alpha: 0.8),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'No Albums Found',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Organize your audio and video clips into albums for better shadowing practice.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.outline,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 48),
              FilledButton.icon(
                onPressed: () => _onAddAlbum(ctx),
                icon: const Icon(Icons.add),
                label: const Text('Create Your First Album'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _page(BuildContext ctx, WidgetRef ref) {
    return Scaffold(appBar: _appBar(ctx, ref), body: _grid());
  }

  AppBar _appBar(BuildContext ctx, WidgetRef ref) {
    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Albums'),
          Consumer(
            builder: (context, ref, child) {
              final albumCount = ref.watch(
                albumListProvider.select((st) {
                  final data = st.value;
                  return data is AlbumListData ? data.albumIdList.length : 0;
                }),
              );
              return Text(
                '$albumCount created albums',
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

  Widget _grid() {
    //grid has to watch whole albumlist, because its order may change, but count stay same.

    return Consumer(
      builder: (context, ref, child) {
        //watch all, albumCount may not change but the album inside list already change
        //etc. album order updated
        final albumIdList = ref.watch(
          albumListProvider.select((st) => (st.value as AlbumListData).albumIdList),
        );
        return GridView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: albumIdList.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            childAspectRatio: 1,
          ),
          itemBuilder: (ctx, i) {
            return AlbumCardUI(albumIdList[i]);
          },
        );
      },
    );
  }

  void _onAddAlbum(BuildContext ctx) async {
    await showDialog(
      context: ctx,
      builder: (context) => const EditAlbumUI(null),
    );
  }
}
