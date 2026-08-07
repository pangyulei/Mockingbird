import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockingbird/tab_albums/album_detail/album_detail_provider.dart';

import '../media_card/media_card_ui.dart';

class AlbumDetailUI extends ConsumerWidget {
  final String? _id;

  const AlbumDetailUI(this._id, {super.key});

  @override
  Widget build(BuildContext ctx, WidgetRef ref) {
    return _page(ctx, ref);
  }

  Widget _page(BuildContext ctx, WidgetRef ref) {
    final theme = Theme.of(ctx);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Consumer(
          builder: (context, ref, child) {
            final (name, count) = ref.watch(
              albumDetailProvider(_id)
                  .select((st) => st.value)
                  .select((st) => (st?.name ?? 'Album not found', st?.assetIdList.length ?? '0')),
            );
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name),
                Text(
                  '$count assets',
                  style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.outline),
                ),
              ],
            );
          },
        ),
        centerTitle: false,
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final assetIdList = ref.watch(
            albumDetailProvider(_id).select((st) => st.value?.assetIdList ?? []),
          );
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: assetIdList.length,
            itemBuilder: (context, i) {
              return MediaCardUI(assetIdList[i]);
            },
          );
        },
      ),
    );
  }
}
