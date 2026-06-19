

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mockingbird/tab_playlists/playlist_detail/media_card_state.dart';

class MediaCardWidget extends StatelessWidget {
  final MediaCardState _state;
  const MediaCardWidget(this._state, {super.key});

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
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            _state.type == .video
                ? Icons.videocam_rounded
                : Icons.audiotrack_rounded,
            color: Theme.of(context).colorScheme.primary,
            size: 28,
          ),
        ),
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
              //TODO press to play media
              // widget._logic.albumDetailPlayMedia(media, context);
            },
          ),
        ),
      ),
    );
  }

}