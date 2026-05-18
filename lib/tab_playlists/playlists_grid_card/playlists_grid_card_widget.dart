import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mockingbird/models/playlist.dart';
import 'package:mockingbird/tab_playlists/playlists_grid_card/playlists_grid_card_interface_ui_events.dart';
import 'package:mockingbird/tab_playlists/playlists_grid_card/playlists_grid_card_state.dart';

class PlaylistsGridCardWidget extends StatefulWidget {
  final Playlist _playlist;
  final PlaylistsGridCardInterfaceUIEvents _handler;
  const PlaylistsGridCardWidget(this._playlist, this._handler, {super.key});

  @override
  State<PlaylistsGridCardWidget> createState() =>
      _PlaylistsGridCardWidgetFactory();
}

class _PlaylistsGridCardWidgetFactory extends State<PlaylistsGridCardWidget> {
  PlaylistsGridCardState _state = const PlaylistsGridCardState();

  void _updateState(PlaylistsGridCardState newState) {
    setState(() {
      _state = newState;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _updateState(
        widget._handler.playlistsGridCardPressedStateChanged(_state, true),
      ),
      onTapUp: (_) {
        _updateState(
          widget._handler.playlistsGridCardPressedStateChanged(_state, false),
        );
        widget._handler.playlistsGridCardOnTap(context, widget._playlist);
      },
      onTapCancel: () => _updateState(
        widget._handler.playlistsGridCardPressedStateChanged(_state, false),
      ),
      child: AnimatedScale(
        scale: _state.isPressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Column(
          children: [
            // Cover image area
            Expanded(
              child: Card(
                margin: const EdgeInsets.all(8),
                elevation: _state.isPressed ? 2 : 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Stack(
                    children: [
                      if (widget._playlist.cover != null)
                        Positioned.fill(
                          child: Opacity(
                            opacity: _state.isPressed ? 0.6 : 0.9,
                            child: Image.file(
                              File(widget._playlist.cover!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      if (widget._playlist.cover == null)
                        const Center(
                          child: Icon(
                            Icons.video_collection,
                            color: Color(0xFF6A6C75),
                            size: 48,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            // Name and song count below cover
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget._playlist.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '0 Songs',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
