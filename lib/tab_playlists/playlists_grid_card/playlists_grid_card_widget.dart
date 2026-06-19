import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mockingbird/model/album.dart';
import 'package:mockingbird/tab_playlists/playlists_grid_card/playlists_grid_card_interface_ui_events.dart';
import 'package:mockingbird/tab_playlists/playlists_grid_card/playlists_grid_card_state.dart';

class PlaylistsGridCardWidget extends StatefulWidget {
  final Album _playlist;
  final PlaylistsGridCardInterfaceUIEvents _logic;
  const PlaylistsGridCardWidget(this._playlist, this._logic, {super.key});

  @override
  State<PlaylistsGridCardWidget> createState() =>
      _PlaylistsGridCardWidgetFactory();
}

class _PlaylistsGridCardWidgetFactory extends State<PlaylistsGridCardWidget> {
  late PlaylistsGridCardState _state;

  @override
  void initState() {
    super.initState();
    _state = PlaylistsGridCardState(playlist: widget._playlist);
  }

  void _updateState(PlaylistsGridCardState newState) {
    setState(() {
      _state = newState;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _updateState(
        widget._logic.playlistsGridCardPressedStateChanged(_state, true),
      ),
      onTapUp: (_) {
        _updateState(
          widget._logic.playlistsGridCardPressedStateChanged(_state, false),
        );
        widget._logic.playlistsGridCardOnTap(context, widget._playlist);
      },
      onTapCancel: () => _updateState(
        widget._logic.playlistsGridCardPressedStateChanged(_state, false),
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
                elevation: _state.isPressed ? 1 : 2,
                shadowColor: Colors.black26,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.5),
                    width: 1,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Stack(
                    children: [
                      if (widget._playlist.coverPathStr != null)
                        Positioned.fill(
                          child: Opacity(
                            opacity: _state.isPressed ? 0.7 : 1.0,
                            child: Image.file(
                              File(widget._playlist.coverPathStr!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      if (widget._playlist.coverPathStr == null)
                        Center(
                          child: Icon(
                            Icons.video_library_rounded,
                            color: Theme.of(context).colorScheme.primary,
                            size: 40,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            // Name and song count below cover
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget._playlist.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: const Color(0xFF191C1E),
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${_state.playlist.medias.length} Medias',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: const Color(0xFF42474E),
                      fontWeight: FontWeight.w500,
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
