import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mockingbird/app/app_route.dart';

import 'album_card_provider.dart';

class AlbumCardUI extends ConsumerWidget {
  final String _id;

  const AlbumCardUI(this._id, {super.key});

  void _onTap(BuildContext ctx, WidgetRef ref) {
    ctx.go(AppRoute.albumDetail(_id));
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

}
