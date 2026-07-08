import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

import 'media_card_state.dart';

enum _MoreItem {
  addSubtitle('add subtitle'),
  deleteSubtitle('delete subtitle'),
  deleteMedia('delete media');

  final String raw;
  const _MoreItem(this.raw);
}

abstract interface class MediaCardUIOutputITF {
  void mediaCard_onPlayMedia(int index);
  void mediaCard_onAddSubtitle(int index);
  void mediaCard_onRemoveSubtitle(int index);
  void mediaCard_onDeleteMedia(int index);
}

class MediaCardUI extends StatelessWidget {
  final MediaCardState _state;
  final MediaCardUIOutputITF _logic;
  final int _index;

  const MediaCardUI(this._index, this._state, this._logic, {super.key});

  @override
  Widget build(BuildContext ctx) {
    final theme = Theme.of(ctx);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _state.isPlaying
            ? colorScheme.primaryContainer.withValues(alpha: 0.15)
            : colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _state.isPlaying
              ? colorScheme.primary.withValues(alpha: 0.5)
              : Colors.white.withValues(alpha: 0.05),
          width: 1,
        ),
      ),
      child: Stack(
        children: [
          ListTile(
            onTap: () => _logic.mediaCard_onPlayMedia(_index),
            horizontalTitleGap: 12,
            contentPadding: const EdgeInsets.only(
              top: 8,
              bottom: 8,
              left: 16,
              right: 44,
            ),
            title: _title(ctx),
            subtitle: _subtitle(ctx),
            trailing: _playButton(ctx),
          ),
          Positioned(top: 4, right: 4, child: _popMenu(ctx)),
        ],
      ),
    );
  }

  Widget _title(BuildContext ctx) {
    final theme = Theme.of(ctx);
    final colorScheme = theme.colorScheme;
    final name = _state.name.trim();
    if (_state.isPlaying && name.isNotEmpty) {
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

  Widget _subtitle(BuildContext ctx) {
    final theme = Theme.of(ctx);
    final colorScheme = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Row(
        children: [
          if (_state.hasSubtitle) ...[
            Icon(Icons.subtitles_rounded, color: colorScheme.outline, size: 14),
            const SizedBox(width: 4),
          ],
          Text(
            _state.type.name.toUpperCase(),
            style: theme.textTheme.labelSmall?.copyWith(
              color: colorScheme.outline,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
            ),
          ),
          if (_state.isPlaying) ...[
            const SizedBox(width: 12),
            _PlayingIndicator(color: colorScheme.primary),
          ],
        ],
      ),
    );
  }

  Widget _playButton(BuildContext ctx) {
    final theme = Theme.of(ctx);
    final colorScheme = theme.colorScheme;
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: _state.isPlaying
            ? colorScheme.primary
            : colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        _state.isPlaying ? Icons.graphic_eq_rounded : Icons.play_arrow_rounded,
        color: _state.isPlaying ? Colors.white : colorScheme.primary,
        size: 28,
      ),
    );
  }

  Widget _popMenu(BuildContext ctx) {
    final theme = Theme.of(ctx);
    final colorScheme = theme.colorScheme;
    return PopupMenuButton<String>(
      icon: Icon(Icons.more_horiz, size: 20, color: colorScheme.outline),
      onSelected: (value) {
        if (value == _MoreItem.addSubtitle.raw) {
          _logic.mediaCard_onAddSubtitle(_index);
        } else if (value == _MoreItem.deleteSubtitle.raw) {
          _logic.mediaCard_onRemoveSubtitle(_index);
        } else if (value == _MoreItem.deleteMedia.raw) {
          _logic.mediaCard_onDeleteMedia(_index);
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: _MoreItem.addSubtitle.raw,
          child: Row(
            children: [
              const Icon(Icons.subtitles_rounded, size: 18),
              const SizedBox(width: 12),
              Text(_state.hasSubtitle ? 'Change Subtitle' : 'Add Subtitle'),
            ],
          ),
        ),
        if (_state.hasSubtitle)
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
              Text('Delete Media', style: TextStyle(color: colorScheme.error)),
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
