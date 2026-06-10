import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mockingbird/models/track.dart';

import 'playlist_detail_interface_ui_events.dart';
import 'playlist_detail_state.dart';

class PlaylistDetailWidget extends StatefulWidget {
  final int _playlistId;
  final PlaylistDetailInterfaceUIEvents _logic;
  const PlaylistDetailWidget(this._playlistId, this._logic, {super.key});

  @override
  State<PlaylistDetailWidget> createState() => _WidgetFactory();
}

class _WidgetFactory extends State<PlaylistDetailWidget> {
  PlaylistDetailState _state = const PlaylistDetailState();

  @override
  void initState() {
    super.initState();
    _updateStateByStream(widget._logic.playlistDetailInitState(widget._playlistId));
  }

  Future<void> _updateStateByStream(Stream<PlaylistDetailState> stream) async {
    await for (final newState in stream) {
      _updateState(newState);
    }
  }

  void _updateState(PlaylistDetailState newState) {
    setState(() {
      _state = newState;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_state.showLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_state.playlist == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Playlist not found'),
        ),
        body: const Center(
          child: Text('Playlist not found'),
        ),
      );
    }

    final tracks = _state.playlist!.tracks.toList();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context),
          if (tracks.isEmpty)
            const SliverFillRemaining(
              child: Center(
                child: Text(
                  'No tracks yet. Tap + to add.',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(vertical: 8),
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
    final hasCover = _state.playlist!.coverPathStr != null;

    return SliverAppBar(
      expandedHeight: 250,
      pinned: true,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          _state.playlist!.name,
          style: TextStyle(
            color: hasCover ? Colors.white : Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.bold,
            shadows: hasCover
                ? [const Shadow(color: Colors.black, blurRadius: 4)]
                : null,
          ),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            if (hasCover)
              Image.file(File(_state.playlist!.coverPathStr!), fit: BoxFit.cover)
            else
              Container(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: Icon(
                  Icons.music_note,
                  size: 100,
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.1),
                ),
              ),
            if (hasCover)
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black54,
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: IconButton.filledTonal(
            icon: const Icon(Icons.playlist_add),
            onPressed: () async {
              _updateState(await widget._logic.playlistDetailAddTracks(_state));
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTrackItem(Track track) {
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
            track.type == TrackType.video
                ? Icons.videocam_rounded
                : Icons.audiotrack_rounded,
            color: Theme.of(context).colorScheme.primary,
            size: 28,
          ),
        ),
        title: Text(
          track.name,
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
              if (track.subPathStr != null) ...[
                Icon(
                  Icons.subtitles_rounded,
                  color: Theme.of(context).colorScheme.primary,
                  size: 14,
                ),
                const SizedBox(width: 4),
              ],
              Text(
                track.type.name.toUpperCase(),
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
              // TODO: Play track
            },
          ),
        ),
      ),
    );
  }
}
