import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:marquee/marquee.dart';
import 'package:mockingbird/app/app_route.dart';

import 'asset_card_provider.dart';

enum _MoreItem {
  deleteMedia('Delete Media');

  final String raw;

  const _MoreItem(this.raw);
}

class AssetCardUI extends ConsumerWidget {
  final String _id;

  const AssetCardUI(this._id, {super.key});

  @override
  Widget build(BuildContext ctx, WidgetRef ref) {
    final theme = Theme.of(ctx);
    final colorScheme = theme.colorScheme;
    final playing = ref.watch(
      assetCardProvider(_id).select((st) => st.value?.playing ?? false),
    );

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: playing
            ? colorScheme.primaryContainer.withValues(alpha: 0.15)
            : colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: playing
              ? colorScheme.primary.withValues(alpha: 0.5)
              : Colors.white.withValues(alpha: 0.05),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            GestureDetector(
              onTap: () => _onPlay(ctx, ref),
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 12,
                  bottom: 12,
                  left: 16,
                  right: 52,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(minHeight: 62),
                        child: _title(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    _playButton(ctx),
                  ],
                ),
              ),
            ),
            Positioned(top: 4, right: 4, child: _popMenu(ctx, ref)),
          ],
        ),
      ),
    );
  }

  Widget _title() {
    return Consumer(
      builder: (ctx, ref, child) {
        final theme = Theme.of(ctx);
        final colorScheme = theme.colorScheme;
        final (name, playing) = ref.watch(
          assetCardProvider(_id)
              .select((st) => st.value)
              .select((st) => (st?.name ?? '', st?.playing ?? false)),
        );
        return Center(
          child: (playing && name.isNotEmpty)
              ? SizedBox(
                  height: 20,
                  child: Marquee(
                    text: name,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                    scrollAxis: Axis.horizontal,
                    blankSpace: 20,
                    velocity: 30,
                  ),
                )
              : Text(
                  name,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
        );
      },
    );
  }

  Widget _playButton(BuildContext ctx) {
    final theme = Theme.of(ctx);
    final colorScheme = theme.colorScheme;
    return Consumer(
      builder: (context, ref, child) {
        final playing = ref.watch(
          assetCardProvider(_id).select((st) => st.value?.playing ?? false),
        );
        return Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: playing
                ? colorScheme.primary
                : colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            playing ? Icons.graphic_eq_rounded : Icons.play_arrow_rounded,
            color: playing ? Colors.white : colorScheme.primary,
            size: 28,
          ),
        );
      },
    );
  }

  Widget _popMenu(BuildContext ctx, WidgetRef ref) {
    final colorScheme = Theme.of(ctx).colorScheme;

    return PopupMenuButton<String>(
      icon: Icon(Icons.more_horiz, size: 20, color: colorScheme.outline),
      onSelected: (value) {
        if (value == _MoreItem.deleteMedia.raw) {
          _onDeleteMedia(ref);
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: _MoreItem.deleteMedia.raw,
          child: Row(
            children: [
              Icon(
                Icons.delete_outline_rounded,
                size: 18,
                color: colorScheme.error,
              ),
              const SizedBox(width: 12),
              Text(
                _MoreItem.deleteMedia.raw,
                style: TextStyle(color: colorScheme.error),
              ),
            ],
          ),
        ),
      ],
      style: IconButton.styleFrom(
        minimumSize: const Size(32, 32),
        padding: EdgeInsets.zero,
        tapTargetSize: .shrinkWrap,
      ),
    );
  }

  void _onPlay(BuildContext ctx, WidgetRef ref) async {
    await ref.read(assetCardProvider(_id).notifier).play();
    if (ctx.mounted) {
      ctx.go(AppRoute.player);
    }
  }

  void _onDeleteMedia(WidgetRef ref) async {
    await ref.read(assetCardProvider(_id).notifier).deleteMedia();
  }
}
