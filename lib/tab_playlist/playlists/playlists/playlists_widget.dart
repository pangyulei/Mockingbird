import 'package:flutter/material.dart';
import 'package:mockingbird/models/playlist.dart';
import 'package:mockingbird/tab_playlist/playlists/playlist_create/playlist_create_handler.dart';
import 'package:mockingbird/tab_playlist/playlists/playlist_create/playlist_create_widget.dart';
import 'package:mockingbird/tab_playlist/playlists/playlists/playlists_events.dart';
import 'package:mockingbird/tab_playlist/playlists/playlists/playlists_state.dart';

import '../playlist_card/playlist_card_handler.dart';
import '../playlist_card/playlist_card_widget.dart';

class PlaylistsWidget extends StatefulWidget {
  final PlaylistsEvents _handler;
  const PlaylistsWidget(this._handler, {super.key});

  @override
  State<PlaylistsWidget> createState() => _PlaylistsWidgetFactory();
}

class _PlaylistsWidgetFactory extends State<PlaylistsWidget> {
  PlaylistsState _state = const PlaylistsState();

  @override
  void initState() {
    super.initState();
    widget._handler.playlistsWidgetInitState().then((newState) {
      _updateState(newState);
    });
  }

  Future<void> _updateStateByStream(Stream<PlaylistsState> stream) async {
    await for (final newState in stream) {
      _updateState(newState);
    }
  }

  void _updateState(PlaylistsState newState) {
    setState(() {
      _state = newState;
    });
  }

  Future<void> _clickedAdd() async {
    final incompletePlaylist = await PlaylistCreateWidget.show(
      context,
      PlaylistCreateHandler(),
    );
    final stream = widget._handler.playlistsWidgetPoppedCreateWidget(
      _state,
      incompletePlaylist,
    );
    await _updateStateByStream(stream);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          _buildGridWidget(),
          if (_state.isLoadingAll) _buildLoadingWidget(),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Playlists',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(
            '${_state.playlists.length} created playlists',
            style: TextStyle(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.6),
              fontSize: 12,
            ),
          ),
        ],
      ),
      centerTitle: false,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: Row(
            spacing: 0,
            children: [
              _buildActionButton(const Icon(Icons.edit, size: 22), () {}),
              _buildActionButton(
                const Icon(Icons.playlist_add, size: 30),
                _clickedAdd,
              ),
            ],
          ),
        ), //padding
      ],
    );
  }

  Widget _buildActionButton(Icon icon, void Function() onTap) {
    return SizedBox(
      width: 50,
      height: double.infinity,
      child: IconButton(onPressed: onTap, icon: icon),
    );
  }

  Widget _buildLoadingWidget() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildGridWidget() {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: _state.playlists.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        final playlist = _state.playlists[index];
        return LongPressDraggable<Playlist>(
          data: playlist,
          feedback: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(24),
            child: SizedBox(
              width: MediaQuery.of(context).size.width / 2 - 20,
              height: MediaQuery.of(context).size.width / 2 - 20,
              child: PlaylistCardWidget(playlist, PlaylistCardHandler()),
            ),
          ),
          childWhenDragging: Opacity(
            opacity: 0.3,
            child: PlaylistCardWidget(playlist, PlaylistCardHandler()),
          ),
          onDragStarted: () {
            // Optional: Add haptic feedback or visual indication
          },
          onDragEnd: (details) {
            // Drag ended
          },
          child: DragTarget<Playlist>(
            onWillAcceptWithDetails: (data) =>
                widget._handler.playlistsWidgetDragTargetWillAccept(
                  _state,
                  playlist,
                  data.data,
                ),
            onAcceptWithDetails: (data) async {
              final stream = widget._handler.playlistsWidgetDragTargetAccepted(
                _state,
                playlist,
                data.data,
              );
              await _updateStateByStream(stream);
            },
            builder: (context, candidateData, rejectedData) {
              return PlaylistCardWidget(playlist, PlaylistCardHandler());
            },
          ),
        );
      },
    );
  }
}
