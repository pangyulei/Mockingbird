import 'package:flutter/material.dart';
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
  // final
  @override
  void initState() {
    super.initState();
    widget._handler.playlistsWidgetInitState().then((newState) {
      _updateState(newState);
    });
  }

  void _updateState(PlaylistsState newState) {
    setState(() {
      _state = newState;
    });
  }

  void _clickedAdd() async {
    final newPlaylist = await PlaylistCreateWidget.show(
      context,
      PlaylistCreateHandler(),
    );
    if (newPlaylist != null) {
      final stream = widget._handler.playlistsWidgetCreatedNewPlaylist(_state);
      await for (final newState in stream) {
        _updateState(newState);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2E3239),
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
      title: const Text('Playlists', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      backgroundColor: const Color(0xFF2E3239),
      elevation: 0,
      centerTitle: false,
      actions: [
        IconButton(
          icon: const Icon(Icons.add, color: Colors.white),
          onPressed: _clickedAdd,
          tooltip: 'Add Playlist',
        ),
      ],
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
        return PlaylistCardWidget(playlist, PlaylistCardHandler());
      },
    );
  }
}
