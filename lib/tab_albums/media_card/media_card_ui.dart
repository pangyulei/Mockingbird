import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:marquee/marquee.dart';
import 'package:mockingbird/app/app_route.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'media_card_state.dart';

enum _MoreItem {
  rename('rename'),
  updateSubtitle('update subtitle'),
  deleteSubtitle('delete subtitle'),
  deleteMedia('delete media');

  final String raw;

  const _MoreItem(this.raw);
}

abstract interface class MediaCardNotifierITF {
  Future<void> play();

  Future<void> deleteSubtitle();

  Future<void> updateSubtitle();

  Future<void> deleteMedia();
}

class MediaCardUI extends ConsumerWidget {
  final ProviderListenable<MediaCardState> _provider;
  final MediaCardNotifierITF _notifier;

  const MediaCardUI(this._provider, this._notifier, {super.key});

  void _onPlay(BuildContext ctx) async {
    await _notifier.play();
    if (ctx.mounted) {
      ctx.go(AppRoute.player);
    }
  }

  void _onUpdateSubtitle() async {
    await _notifier.updateSubtitle();
  }

  void _onDeleteSubtitle() async {
    await _notifier.deleteSubtitle();
  }

  void _onDeleteMedia() async {
    await _notifier.deleteMedia();
  }

  void _onRenameMedia() async {
    //TODO popup rename media dialog
  }

  @override
  Widget build(BuildContext ctx, WidgetRef ref) {
    final theme = Theme.of(ctx);
    final colorScheme = theme.colorScheme;
    final isPlaying = ref.watch(_provider.select((s) => s.isPlaying));
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isPlaying
            ? colorScheme.primaryContainer.withValues(alpha: 0.15)
            : colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isPlaying
              ? colorScheme.primary.withValues(alpha: 0.5)
              : Colors.white.withValues(alpha: 0.05),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            InkWell(
              onTap: () => _onPlay(ctx),
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
                        child: Column(
                          mainAxisAlignment: .center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [_title(), _subtitle()],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    _playButton(ctx, ref),
                  ],
                ),
              ),
            ),
            Positioned(top: 4, right: 4, child: _popMenu(ctx)),
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
        final (name, isPlaying) = ref.watch(
          _provider.select((s) => (s.name.trim(), s.isPlaying)),
        );
        if (isPlaying && name.isNotEmpty) {
          return SizedBox(
            height: 20,
            child: Marquee(
              text: name,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
              scrollAxis: .horizontal,
              blankSpace: 20,
              velocity: 30,
            ),
          );
          // fontWeight: _state.isPlaying ? FontWeight.bold : FontWeight.w600,
          // color: _state.isPlaying ? colorScheme.primary : colorScheme.onSurface,
        } else {
          return Text(
            name,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          );
        }
      },
    );
  }

  Widget _subtitle() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Consumer(
        builder: (ctx, ref, child) {
          final theme = Theme.of(ctx);
          final colorScheme = theme.colorScheme;
          final (hasSubtitle, type, isPlaying) = ref.watch(
            _provider.select((s) => (s.hasSubtitle, s.type, s.isPlaying)),
          );
          return Row(
            children: [
              Icon(
                hasSubtitle
                    ? Icons.subtitles_rounded
                    : Icons.subtitles_off_rounded,
                color: hasSubtitle ? colorScheme.outline : colorScheme.error,
                size: 14,
              ),
              const SizedBox(width: 4),
              Text(
                type.name.toUpperCase(),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colorScheme.outline,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
              if (isPlaying) ...[
                const SizedBox(width: 12),
                _PlayingIndicator(color: colorScheme.primary),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _playButton(BuildContext ctx, WidgetRef ref) {
    final theme = Theme.of(ctx);
    final colorScheme = theme.colorScheme;
    final isPlaying = ref.watch(_provider.select((s) => s.isPlaying));
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: isPlaying
            ? colorScheme.primary
            : colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        isPlaying ? Icons.graphic_eq_rounded : Icons.play_arrow_rounded,
        color: isPlaying ? Colors.white : colorScheme.primary,
        size: 28,
      ),
    );
  }

  Widget _popMenu(BuildContext ctx) {
    final theme = Theme.of(ctx);
    final colorScheme = theme.colorScheme;
    return Consumer(
      builder: (context, ref, child) {
        final hasSubtitle = ref.watch(_provider.select((s) => s.hasSubtitle));
        return PopupMenuButton<String>(
          icon: Icon(Icons.more_horiz, size: 20, color: colorScheme.outline),
          onSelected: (value) {
            if (value == _MoreItem.updateSubtitle.raw) {
              _onUpdateSubtitle();
            } else if (value == _MoreItem.deleteSubtitle.raw) {
              _onDeleteSubtitle();
            } else if (value == _MoreItem.deleteMedia.raw) {
              _onDeleteMedia();
            } else if (value == _MoreItem.rename.raw) {
              _onRenameMedia();
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: _MoreItem.rename.raw,
              child: const Row(
                children: [
                  Icon(Icons.edit_rounded, size: 18),
                  SizedBox(width: 12),
                  Text('Rename'),
                ],
              ),
            ),
            PopupMenuItem(
              value: _MoreItem.updateSubtitle.raw,
              child: Row(
                children: [
                  const Icon(Icons.subtitles_rounded, size: 18),
                  const SizedBox(width: 12),
                  Consumer(
                    builder: (context, ref, child) {
                      final hasSubtitle = ref.watch(
                        _provider.select((s) => s.hasSubtitle),
                      );
                      return Text(
                        hasSubtitle ? 'Change Subtitle' : 'Add Subtitle',
                      );
                    },
                  ),
                ],
              ),
            ),
            if (hasSubtitle)
              PopupMenuItem(
                value: _MoreItem.deleteSubtitle.raw,
                child: Row(
                  children: [
                    Icon(
                      Icons.subtitles_off_rounded,
                      size: 18,
                      color: colorScheme.error,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Delete Subtitle',
                      style: TextStyle(color: colorScheme.error),
                    ),
                  ],
                ),
              ),
            const PopupMenuDivider(),
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
                    'Delete Media',
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
      },
    );
  }
}

class _PlayingIndicator extends StatelessWidget {
  final Color color;

  const _PlayingIndicator({required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 1),
          width: 2,
          height: 8 + (index % 2 == 0 ? 4 : 0),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(1),
          ),
        );
      }),
    );
  }
}
