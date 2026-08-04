import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mockingbird/app/app_route.dart';

import 'album_card_provider.dart';

enum _MoreItem {
  delete('Delete');

  final String raw;

  const _MoreItem(this.raw);
}

class AlbumCardUI extends ConsumerWidget {
  final String _id;

  const AlbumCardUI(this._id, {super.key});

  void _onTap(BuildContext ctx, WidgetRef ref) {
    ctx.go(AppRoute.albumDetail(_id));
  }

  void _onDelete(BuildContext ctx, WidgetRef ref) async {
    // if (await confirmDelete(ctx, ref)) {
    //   await ref.read(albumCardProvider(_id).notifier).delete();
    // }
  }

  @override
  Widget build(BuildContext ctx, WidgetRef ref) {
    final theme = Theme.of(ctx);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: () => _onTap(ctx, ref),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Cover image area
          Icon(
            Icons.folder_rounded,
            color: colorScheme.primary.withValues(alpha: 0.5),
            size: 56,
          ),
          // Name and song count below cover
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Consumer(
                  builder: (context, ref, child) {
                    final name = ref.watch(
                      albumCardProvider(_id).select((st) => st.value?.name ?? ''),
                    );
                    return Text(
                      name,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    );
                  },
                ),
                const SizedBox(height: 2),
                Consumer(
                  builder: (context, ref, child) {
                    final mediaCount = ref.watch(
                      albumCardProvider(_id).select((st) => st.value?.mediaCount ?? 0),
                    );
                    return Text(
                      '$mediaCount Medias',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.outline,
                        fontWeight: FontWeight.w500,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget _menu(BuildContext ctx, WidgetRef ref) {
  //   final colorScheme = Theme.of(ctx).colorScheme;
  //   return PopupMenuButton<String>(
  //     icon: const Icon(Icons.more_horiz, size: 20, color: Colors.white),
  //     onSelected: (value) {
  //       if (value == _MoreItem.delete.raw) {
  //         _onDelete(ctx, ref);
  //       }
  //     },
  //     itemBuilder: (context) => [
  //       PopupMenuItem(
  //         value: _MoreItem.delete.raw,
  //         child: Row(
  //           children: [
  //             Icon(Icons.delete_outline, size: 18, color: colorScheme.error),
  //             const SizedBox(width: 12),
  //             Text(_MoreItem.delete.raw, style: TextStyle(color: colorScheme.error)),
  //           ],
  //         ),
  //       ),
  //     ],
  //     style: IconButton.styleFrom(
  //       backgroundColor: Colors.black.withValues(alpha: 0.3),
  //       minimumSize: const Size(32, 32),
  //       padding: EdgeInsets.zero,
  //       tapTargetSize: MaterialTapTargetSize.shrinkWrap,
  //     ),
  //   );
  // }

}
