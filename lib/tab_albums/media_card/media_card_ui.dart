import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:marquee/marquee.dart';
import 'package:mockingbird/app/app_route.dart';
import 'package:mockingbird/tab_albums/media_card/media_card_provider.dart';
import 'package:mockingbird/tool/shrink_ui.dart';

class MediaCardUI extends ConsumerWidget {
  final String _id;

  const MediaCardUI(this._id, {super.key});

  @override
  Widget build(BuildContext ctx, WidgetRef ref) {
    final theme = Theme.of(ctx);
    final colorScheme = theme.colorScheme;
    final playing = ref.watch(mediaCardProvider(_id).select((st) => st.playing));

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: playing ? colorScheme.primaryContainer.withValues(alpha: 0.15) : colorScheme.surface,
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
        child: GestureDetector(
          onTap: () => _onPlay(ctx, ref),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(minHeight: 62),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [_title(), _subtitle()],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                _playButton(ctx),
              ],
            ),
          ),
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
          mediaCardProvider(
            _id,
          ).select((st) => (st.name, st.playing)),
        );
        return (playing && name.isNotEmpty)
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
                textAlign: TextAlign.left,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              );
      },
    );
  }

  Widget _subtitle() {
    return Consumer(
      builder: (ctx, ref, child) {
        // Mocking hasSubtitle for now, as requested.
        const hasSubtitle = true;

        if (!hasSubtitle) return const ShrinkUI();

        return const Padding(
          padding: EdgeInsets.only(top: 4),
          child: Row(children: [Icon(Icons.subtitles_rounded, size: 16, color: Colors.blue)]),
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
          mediaCardProvider(_id).select((st) => st.playing),
        );
        return Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: playing ? colorScheme.primary : colorScheme.surfaceContainerHighest,
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

  void _onPlay(BuildContext ctx, WidgetRef ref) async {
    await ref.read(mediaCardProvider(_id).notifier).play();
    if (ctx.mounted) {
      ctx.go(AppRoute.player);
    }
  }
}
