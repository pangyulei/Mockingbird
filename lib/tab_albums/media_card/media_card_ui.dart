import 'package:flutter/material.dart';

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
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      elevation: _state.isPlaying ? 2 : 0,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: _state.isPlaying
              ? colorScheme.primary
              : colorScheme.outlineVariant.withValues(alpha: 0.4),
          width: _state.isPlaying ? 2 : 1,
        ),
      ),
      color:
          _state.isPlaying
              ? colorScheme.primaryContainer.withValues(alpha: 0.3)
              : null,
      child: Stack(
        children: [
          ListTile(
            horizontalTitleGap: 0,
            contentPadding: const EdgeInsets.only(
              left: 12,
              top: 4,
              bottom: 4,
              right: 34,
            ),
            title: Text(
              _state.name,
              style: TextStyle(
                fontWeight: _state.isPlaying ? FontWeight.bold : FontWeight.w600,
                color: _state.isPlaying ? colorScheme.primary : const Color(0xFF191C1E),
                fontSize: 14,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Row(
                children: [
                  if (_state.hasSubtitle) ...[
                    Icon(
                      Icons.subtitles_rounded,
                      color: _state.isPlaying ? colorScheme.primary : colorScheme.secondary,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                  ],
                  Text(
                    _state.type.name.toUpperCase(),
                    style: TextStyle(
                      color: _state.isPlaying ? colorScheme.primary.withValues(alpha: 0.8) : const Color(0xFF42474E),
                      fontWeight: FontWeight.w600,
                      fontSize: 11,
                      letterSpacing: 0.5,
                    ),
                  ),
                  if (_state.isPlaying) ...[
                    const SizedBox(width: 8),
                    _PlayingIndicator(color: colorScheme.primary),
                  ],
                ],
              ),
            ),
            trailing: Container(
              decoration: BoxDecoration(
                color: _state.isPlaying ? colorScheme.primary : colorScheme.primary.withValues(alpha: 0.9),
                shape: BoxShape.circle,
                boxShadow: _state.isPlaying ? [
                  BoxShadow(
                    color: colorScheme.primary.withValues(alpha: 0.3),
                    blurRadius: 8,
                    spreadRadius: 1,
                  )
                ] : null,
              ),
              child: IconButton(
                icon: Icon(
                  _state.isPlaying ? Icons.graphic_eq_rounded : Icons.play_arrow_rounded,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: () {
                  _logic.mediaCard_onPlayMedia(_index);
                },
              ),
            ),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, size: 20),
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
                      const SizedBox(width: 8),
                      Text(
                        _state.hasSubtitle ? 'Change Subtitle' : 'Add Subtitle',
                      ),
                    ],
                  ),
                ),
                if (_state.hasSubtitle)
                  PopupMenuItem(
                    value: _MoreItem.deleteSubtitle.raw,
                    child: const Row(
                      children: [
                        Icon(Icons.subtitles_off_rounded, size: 18),
                        SizedBox(width: 8),
                        Text('Delete Subtitle'),
                      ],
                    ),
                  ),
                PopupMenuItem(
                  value: _MoreItem.deleteMedia.raw,
                  child: const Row(
                    children: [
                      Icon(Icons.delete_rounded, size: 18),
                      SizedBox(width: 8),
                      Text('Delete Media'),
                    ],
                  ),
                ),
              ],
              style: IconButton.styleFrom(
                minimumSize: const Size(28, 28),
                padding: EdgeInsets.zero,
                tapTargetSize: .shrinkWrap,
              ),
            ),
          ),
        ],
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
