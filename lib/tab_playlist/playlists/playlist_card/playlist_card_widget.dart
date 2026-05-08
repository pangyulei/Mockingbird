import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mockingbird/models/playlist.dart';
import 'package:mockingbird/tab_playlist/playlists/playlist_card/playlist_card_events.dart';
import 'package:mockingbird/tab_playlist/playlists/playlist_card/playlist_card_state.dart';

class PlaylistCardWidget extends StatefulWidget {
  final Playlist playlist;
  final PlaylistCardEvents _handler;
  const PlaylistCardWidget(this.playlist, this._handler, {super.key});

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
    const bgColor = Color(0xFF1E1F23);
    const lightShadow = Color(0xFF2A2B31);
    const darkShadow = Color(0xFF121216);

    return GestureDetector(
      onTapDown: (_) => _updateState(
        widget._handler.playlistCardWidgetPressedStateChanged(_state, true),
      ),
      onTapUp: (_) {
        _updateState(
          widget._handler.playlistCardWidgetPressedStateChanged(_state, false),
        );
        widget._handler.playlistCardWidgetOnTap(widget.playlist);
      },
      onTapCancel: () => _updateState(
        widget._handler.playlistCardWidgetPressedStateChanged(_state, false),
      ),
      child: AnimatedScale(
        scale: _state.isPressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(24),
            gradient: _state.isPressed
                ? const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [darkShadow, lightShadow],
                  )
                : null,
            boxShadow: _state.isPressed
                ? []
                : [
                    const BoxShadow(
                      color: darkShadow,
                      offset: Offset(6, 6),
                      blurRadius: 12,
                    ),
                    const BoxShadow(
                      color: lightShadow,
                      offset: Offset(-6, -6),
                      blurRadius: 12,
                    ),
                  ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Stack(
              children: [
                if (widget.playlist.cover != null)
                  Positioned.fill(
                    child: Opacity(
                      opacity: _state.isPressed ? 0.6 : 0.9,
                      child: Image.file(
                        File(widget.playlist.cover!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                if (widget.playlist.cover == null)
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
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.6),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.playlist.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            // fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          '0 Songs',
                          style: TextStyle(
                            color: Color(0xFF6A6C75),
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
