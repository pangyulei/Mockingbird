import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockingbird/tab_assets/album_card/album_card_ui.dart';
import 'package:mockingbird/tab_assets/album_list/album_list_provider.dart';
import 'package:mockingbird/tab_assets/album_list/album_list_state.dart';
import 'package:mockingbird/tool/shrink_ui.dart';

import '../../tool/extensions.dart';

class AlbumListUI extends ConsumerWidget {
  const AlbumListUI({super.key});

  @override
  Widget build(BuildContext ctx, WidgetRef ref) {
    final stateType = ref.watch(
      albumListProvider.select((st) => st.value?.runtimeType),
    );
    debugPrint('albumlist stateType: $stateType');
    // showLoading(stateType == null);
    switch (stateType) {
      case AlbumListNull:
        //result is null
        return _empty(ctx, ref);
      case AlbumListData:
        //result is data
        return _page(ctx, ref);
      default:
        //Null/null, means its asyncloading without data, initial load situation
        return Scaffold(appBar: _appBar(ctx, ref));
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
              final int? albumCount = ref.watch(
                albumListProvider.select(
                  (st) => st.value?.as<AlbumListData>()?.AlbumIdList.length,
                ),
              );
              if (albumCount == null) return const ShrinkUI();
              return Text(
                '$albumCount albums',
                style: Theme.of(ctx).textTheme.bodySmall?.copyWith(
                  color: Theme.of(ctx).colorScheme.outline,
                ),
              );
            },
          ),
        ],
      ),
      centerTitle: false,
      actions: const [],
    );
  }

  Widget _grid() {
    //grid has to watch whole albumlist, because its order may change, but count stay same.

    return Consumer(
      builder: (context, ref, child) {
        //watch all, albumCount may not change but the album inside list already change
        //etc. album order updated
        final albumIdList = ref.watch(
          albumListProvider.select(
            (st) => st.value?.as<AlbumListData>()?.AlbumIdList,
          ),
        );
        if (albumIdList == null) return const ShrinkUI();
        return GridView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: albumIdList.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
          ),
          itemBuilder: (ctx, i) {
            return AlbumCardUI(albumIdList[i]);
          },
        );
      },
    );
  }
}
