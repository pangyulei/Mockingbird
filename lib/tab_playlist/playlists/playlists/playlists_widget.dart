import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mockingbird/models/playlist.dart';
import 'package:mockingbird/tab_playlist/playlists/playlist_create/playlist_create_handler.dart';
import 'package:mockingbird/tab_playlist/playlists/playlist_create/playlist_create_widget.dart';
import 'package:mockingbird/tab_playlist/playlists/playlists/playlists_events.dart';
import 'package:mockingbird/tab_playlist/playlists/playlists/playlists_state.dart';

class PlaylistsWidget extends StatefulWidget {
  final PlaylistsEvents _handler;
  const PlaylistsWidget(this._handler, {super.key});

  @override
  State<PlaylistsWidget> createState() => _PlaylistsWidgetFactory();
}

class _PlaylistsWidgetFactory extends State<PlaylistsWidget> {
  PlaylistsState _state = const PlaylistsState([]);
  // final List<_PlaylistData> _playlists = List.generate(
  //   20,
  //   (index) => _PlaylistData(
  //     title: 'Playlist ${index + 1}',
  //     coverColor: Colors.primaries[index % Colors.primaries.length],
  //   ),
  // );
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget._handler.playlistsWidgetInitState().then((newState) {
      setState(() {
        _state = newState;
      });
    },);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Playlists'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              await PlaylistCreateWidget.show(context, PlaylistCreateHandler());
            },
            tooltip: 'Add Playlist',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: GridView.builder(
          itemCount: _state.playlists.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 1,
          ),
          itemBuilder: (context, index) {
            final playlist = _state.playlists[index];
            return PlaylistCard(playlist: playlist);
          },
        ),
      ),
    );
  }
}

class PlaylistCard extends StatelessWidget {
  const PlaylistCard({super.key, required this.playlist});

  final Playlist playlist;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(16),
              image: playlist.cover != null
                  ? DecorationImage(
                      image: FileImage(File(playlist.cover!)),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: playlist.cover == null
                ? const Icon(Icons.music_note, color: Colors.white70, size: 40)
                : null,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          playlist.name,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
