import 'package:collection/collection.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marquee/marquee.dart';
import 'package:mockingbird/db/entities/en_media.dart';
import 'package:mockingbird/db/entities/en_subtitle.dart';
import 'package:mockingbird/tool/subtitle_parser.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'media_card_state.dart';

enum _MoreItem {
  addSubtitle('add subtitle'),
  deleteSubtitle('delete subtitle'),
  deleteMedia('delete media');

  final String raw;

  const _MoreItem(this.raw);
}

abstract interface class MediaCardNotifierITF {
  int? get id;
  Future<void> play();
  Future<void> deleteSubtitle();
  Future<void> addSubtitle(EnSubtitle subtitle);
  Future<void> deleteMedia();
}

class MediaCardUI extends ConsumerWidget {
  final ProviderListenable<AsyncValue<MediaCardState>> _provider;
  final MediaCardNotifierITF _notifier;
  const MediaCardUI(this._provider, this._notifier, {super.key});

  void _onPlay() async {
    await _notifier.play();
  }

  void _onAddSubtitle() async {
    final subtitlePath = await _pickOneSubtitle();
    if (subtitlePath == null) return;
    final subtitle = await SubtitleParser.parsePath(subtitlePath);
    if (subtitle == null) return;
    await _notifier.addSubtitle(subtitle);
  }

  void _onDeleteSubtitle() async {
    await _notifier.deleteSubtitle();
  }

  void _onDeleteMedia() async {
    await _notifier.deleteMedia();
  }

  @override
  Widget build(BuildContext ctx, WidgetRef ref) {
    final theme = Theme.of(ctx);
    final colorScheme = theme.colorScheme;
    final isPlaying =
        ref.watch(_provider.select((s) => s.value?.isPlaying)) ?? false;
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
              onTap: _onPlay,
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
                          children: [_title(ctx, ref), _subtitle(ctx, ref)],
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

  Widget _title(BuildContext ctx, WidgetRef ref) {
    final theme = Theme.of(ctx);
    final colorScheme = theme.colorScheme;
    final (name, isPlaying) = ref.watch(
      _provider.select(
        (s) => (s.value?.name.trim() ?? '', s.value?.isPlaying ?? false),
      ),
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
  }

  Widget _subtitle(BuildContext ctx, WidgetRef ref) {
    final theme = Theme.of(ctx);
    final colorScheme = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Consumer(
        builder: (context, ref, child) {
          final (hasSubtitle, type, isPlaying) = ref.watch(
            _provider.select(
              (s) => (
                s.value?.hasSubtitle ?? false,
                s.value?.type ?? .video,
                s.value?.isPlaying ?? false,
              ),
            ),
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
    final isPlaying = ref.watch(
      _provider.select((s) => s.value?.isPlaying ?? false),
    );
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
        final hasSubtitle = ref.watch(
          _provider.select((s) => s.value?.hasSubtitle ?? false),
        );
        return PopupMenuButton<String>(
          icon: Icon(Icons.more_horiz, size: 20, color: colorScheme.outline),
          onSelected: (value) {
            if (value == _MoreItem.addSubtitle.raw) {
              _onAddSubtitle();
            } else if (value == _MoreItem.deleteSubtitle.raw) {
              _onDeleteSubtitle();
            } else if (value == _MoreItem.deleteMedia.raw) {
              _onDeleteMedia();
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: _MoreItem.addSubtitle.raw,
              child: Row(
                children: [
                  const Icon(Icons.subtitles_rounded, size: 18),
                  const SizedBox(width: 12),
                  Consumer(
                    builder: (context, ref, child) {
                      final hasSubtitle = ref.watch(
                        _provider.select((s) => s.value?.hasSubtitle ?? false),
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

  Future<String?> _pickOneSubtitle() async {
    try {
      final pickedFiles = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: [...kSubtitleExtensions],
        allowMultiple: false,
      );
      final subtitlePath = pickedFiles?.files
          .firstWhereOrNull(
            (f) =>
                kSubtitleExtensions.contains(f.extension?.toLowerCase() ?? ''),
          )
          ?.path;
      return subtitlePath;
    } catch (e) {
      debugPrint('Error adding subtitle: $e');
      return null;
    }
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
