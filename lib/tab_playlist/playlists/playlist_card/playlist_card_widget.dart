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
    return GestureDetector(
      onTapDown: (_) => _updateState(
        widget._handler.playlistCardWidgetClickedDown(_state),
      ),
      onTap: () => _updateState(
        widget._handler.playlistCardWidgetClickedUpInside(_state),
      ),
      onTapCancel: () => _updateState(
        widget._handler.playlistCardWidgetClickedUpOutside(_state),
      ),
      child: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFF2E3239),
          borderRadius: BorderRadius.circular(20),
          boxShadow: _state.isPressed
              ? [] // No shadows when pressed makes it look "flat/pushed"
              : [
                  const BoxShadow(
                    color: Color(0xFF23262B),
                    offset: Offset(4, 4),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                  const BoxShadow(
                    color: Color(0xFF393E46),
                    offset: Offset(-4, -4),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
          image: widget.playlist.cover != null
              ? DecorationImage(
                  image: FileImage(File(widget.playlist.cover!)),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            if (widget.playlist.cover == null)
              const Center(
                child: Icon(
                  Icons.music_note,
                  color: Colors.white70,
                  size: 40,
                ),
              ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 4,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.7),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Text(
                  widget.playlist.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
