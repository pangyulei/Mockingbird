import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mockingbird/models/track.dart';

import 'playlist_events.dart';
import 'playlist_state.dart';

class PlaylistWidget extends StatefulWidget {
  final int _playlistId;
  final PlaylistEvents _handler;
  const PlaylistWidget(this._playlistId, this._handler, {super.key});

  @override
  State<PlaylistWidget> createState() => _PlaylistWidgetFactory();
}

class _PlaylistWidgetFactory extends State<PlaylistWidget> {
  PlaylistState _state = const PlaylistState();

  @override
  void initState() {
    super.initState();
    _updateStateByStream(
      widget._handler.playlistWidgetInitState(widget._playlistId),
    );
  }

  Future<void> _updateStateByStream(Stream<PlaylistState> stream) async {
    await for (final newState in stream) {
      _updateState(newState);
    }
  }

  void _updateState(PlaylistState newState) {
    setState(() {
      _state = newState;
    });
  }

  Future<void> _handleImportMedia() async {
    await widget._handler.playlistWidgetAddTracks(_state);

  }

  @override
  Widget build(BuildContext context) {
    const bgColor = Color(0xFF1E1F23);

    if (_state.showLoading) {
      return const Scaffold(
        backgroundColor: bgColor,
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFFFF4D00)),
        ),
      );
    }

    if (_state.playlist == null) {
      return Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: bgColor,
          title: const Text('Playlist not found'),
        ),
        body: const Center(
          child: Text('Playlist not found', style: TextStyle(color: Colors.white)),
        ),
      );
    }

    final tracks = _state.playlist!.tracks.toList();
    tracks.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

    return Scaffold(
      backgroundColor: bgColor,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context),
          if (tracks.isEmpty)
            const SliverFillRemaining(
              child: Center(
                child: Text(
                  'No tracks yet. Tap + to add.',
                  style: TextStyle(color: Color(0xFF6A6C75)),
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _buildTrackItem(tracks[index]),
                  childCount: tracks.length,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    const bgColor = Color(0xFF1E1F23);
    final hasCover = _state.playlist!.cover != null;

    return SliverAppBar(
      expandedHeight: 250,
      pinned: true,
      backgroundColor: bgColor,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          _state.playlist!.name,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            shadows: [Shadow(color: Colors.black, blurRadius: 4)],
          ),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            if (hasCover)
              Image.file(File(_state.playlist!.cover!), fit: BoxFit.cover)
            else
              Container(
                color: const Color(0xFF121216),
                child: const Icon(
                  Icons.music_note,
                  size: 100,
                  color: Color(0xFF2A2B31),
                ),
              ),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Color(0xAA1E1F23), Color(0xFF1E1F23)],
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: _buildNeumorphicButton(
            icon: Icons.playlist_add,
            onTap: _handleImportMedia,
          ),
        ),
      ],
    );
  }

  Widget _buildNeumorphicButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1F23),
          shape: BoxShape.circle,
          boxShadow: [
            const BoxShadow(
              color: Color(0xFF121216),
              offset: Offset(4, 4),
              blurRadius: 10,
            ),
            const BoxShadow(
              color: Color(0xFF2A2B31),
              offset: Offset(-4, -4),
              blurRadius: 10,
            ),
          ],
        ),
        child: Icon(icon, color: const Color(0xFFFF4D00), size: 28),
      ),
    );
  }

  Widget _buildTrackItem(Track track) {
    const lightShadow = Color(0xFF2A2B31);
    const darkShadow = Color(0xFF121216);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1F23),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          const BoxShadow(color: darkShadow, offset: Offset(4, 4), blurRadius: 8),
          const BoxShadow(color: lightShadow, offset: Offset(-4, -4), blurRadius: 8),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFF121216),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              track.mediaType == MediaType.video
                  ? Icons.videocam_rounded
                  : Icons.audiotrack_rounded,
              color: const Color(0xFFFF4D00),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  track.fileName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    if (track.subtitlePath != null) ...[
                      const Icon(Icons.subtitles_rounded, color: Color(0xFF6A6C75), size: 14),
                      const SizedBox(width: 4),
                    ],
                    Text(
                      track.mediaType.name.toUpperCase(),
                      style: const TextStyle(color: Color(0xFF6A6C75), fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.play_arrow_rounded, color: Color(0xFFFF4D00)),
            onPressed: () {
              // TODO: Play track
            },
          ),
        ],
      ),
    );
  }
}
