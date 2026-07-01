

import 'package:flutter/cupertino.dart';
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
  void mediaCard_play(int index);
  void mediaCard_addSubtitle(int index);
  void mediaCard_removeSubtitle(int index);
  void mediaCard_deleteMedia(int index);
}


class MediaCardUI extends StatelessWidget {
  final MediaCardState _state;
  final MediaCardUIOutputITF _logic;

  const MediaCardUI({
    required this._state,
    required this._logic,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.4),
          width: 1,
        ),
      ),
      child: Stack(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.only(left: 16, top: 8, bottom: 8, right: 38),
            // leading: Container(
            //   width: 52,
            //   height: 52,
            //   decoration: BoxDecoration(
            //     color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.7),
            //     borderRadius: BorderRadius.circular(12),
            //   ),
            //   child: Icon(
            //     _state.type == MediaType.video
            //         ? Icons.videocam_rounded
            //         : Icons.audiotrack_rounded,
            //     color: Theme.of(context).colorScheme.primary,
            //     size: 28,
            //   ),
            // ),
            title: Text(
              _state.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF191C1E),
                fontSize: 16,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Row(
                children: [
                  if (_state.hasSubtitle) ...[
                    Icon(
                      Icons.subtitles_rounded,
                      color: Theme.of(context).colorScheme.primary,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                  ],
                  Text(
                    _state.type.name.toUpperCase(),
                    style: const TextStyle(
                      color: Color(0xFF42474E),
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
            trailing: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.play_arrow_rounded,
                  color: Colors.white,
                ),
                onPressed: () {
                  _logic.mediaCard_play(_state.index);
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
                  _logic.mediaCard_addSubtitle(_state.index);

                } else if (value == _MoreItem.deleteSubtitle.raw) {
                  _logic.mediaCard_removeSubtitle(_state.index);

                } else if (value == _MoreItem.deleteMedia.raw) {
                  _logic.mediaCard_deleteMedia(_state.index);
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: _MoreItem.addSubtitle.raw,
                  child: Row(
                    children: [
                      const Icon(Icons.subtitles_rounded, size: 18),
                      const SizedBox(width: 8),
                      Text(_state.hasSubtitle ? 'Change Subtitle' : 'Add Subtitle'),
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
