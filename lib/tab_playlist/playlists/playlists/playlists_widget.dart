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
      backgroundColor: const Color(0xFF1E1F23),
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
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '${_state.playlists.length} created playlists',
            style: const TextStyle(color: Color(0xFF6A6C75), fontSize: 12),
          ),
        ],
      ),
      backgroundColor: const Color(0xFF1E1F23),
      elevation: 0,
      centerTitle: false,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16, top: 12, bottom: 4),
          child: GestureDetector(
            onTapDown: (_) => _updateState(
              widget._handler.playlistsWidgetAddButtonStateChanged(
                _state,
                true,
              ),
            ),
            onTapUp: (_) => _updateState(
              widget._handler.playlistsWidgetAddButtonStateChanged(
                _state,
                false,
              ),
            ),
            onTapCancel: () => _updateState(
              widget._handler.playlistsWidgetAddButtonStateChanged(
                _state,
                false,
              ),
            ),
            onTap: _clickedAdd,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 100),
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF1E1F23),
                borderRadius: BorderRadius.circular(20),
                boxShadow: _state.isAddButtonPressed
                    ? [
                        const BoxShadow(
                          color: Color(0xFF121216),
                          offset: Offset(2, 2),
                          blurRadius: 2,
                        ),
                        const BoxShadow(
                          color: Color(0xFF2A2B31),
                          offset: Offset(-2, -2),
                          blurRadius: 2,
                        ),
                      ]
                    : [
                        const BoxShadow(
                          color: Color(0xFF121216),
                          offset: Offset(4, 4),
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                        const BoxShadow(
                          color: Color(0xFF2A2B31),
                          offset: Offset(-4, -4),
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                      ],
              ),
              child: const Icon(
                Icons.playlist_add,
                color: Color(0xFFFF4D00),
                size: 20,
              ),
            ),
          ),
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
