import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mockingbird/models/playlist.dart';
import 'package:mockingbird/tab_playlist/playlists/playlist_card/playlist_card_events.dart';
import 'package:mockingbird/tab_playlist/playlists/playlist_card/playlist_card_state.dart';

class PlaylistCardWidget extends StatefulWidget {
  final Playlist _playlist;
  final PlaylistCardEvents _handler;
  const PlaylistCardWidget(this._playlist, this._handler, {super.key});

  @override
  State<PlaylistCardWidget> createState() => _PlaylistCardWidgetState();
}

class _PlaylistCardWidgetState extends State<PlaylistCardWidget> {
  PlaylistCardState _state = const PlaylistCardState();

  void _updateState(PlaylistCardState newState) {
    setState(() {
      _state = newState;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _updateState(
        widget._handler.playlistCardWidgetPressedStateChanged(_state, true),
      ),
      onTapUp: (_) {
        _updateState(
          widget._handler.playlistCardWidgetPressedStateChanged(_state, false),
        );
        widget._handler.playlistCardWidgetOnTap(widget._playlist);
      },
      onTapCancel: () => _updateState(
        widget._handler.playlistCardWidgetPressedStateChanged(_state, false),
      ),
      child: AnimatedScale(
        scale: _state.isPressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 100),
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
                      color: Color(0xFF6A6C75), //Color(0xFFFF4D00),
                      size: 24,
                    ),
                  ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                      bottom: 16,
                    ),
                    decoration: widget._playlist.cover == null
                        ? null
                        : BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Theme.of(context).colorScheme.surface.withValues(alpha: 1),
                                Theme.of(context).colorScheme.surface.withValues(alpha: 0.9),
                                Theme.of(context).colorScheme.surface.withValues(alpha: 0.8),
                                Theme.of(context).colorScheme.surface.withValues(alpha: 0.3),
                              ],
                            ),
                          ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget._playlist.name,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          '0 Songs',
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
