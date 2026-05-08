import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mockingbird/tab_playlist/playlists/playlist_create/playlist_create_widget.dart';

class PlaylistsWidget extends StatefulWidget {
  const PlaylistsWidget({super.key});

  @override
  State<PlaylistsWidget> createState() => _PlaylistsWidgetFactory();
}

class _PlaylistsWidgetFactory extends State<PlaylistsWidget> {
  final List<_PlaylistData> _playlists = List.generate(
    20,
    (index) => _PlaylistData(
      title: 'Playlist ${index + 1}',
      coverColor: Colors.primaries[index % Colors.primaries.length],
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Playlists'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const PlaylistCreateWidget();
                },
              );
            },
            tooltip: 'Add Playlist',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: GridView.builder(
          itemCount: _playlists.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 1,
          ),
          itemBuilder: (context, index) {
            final playlist = _playlists[index];
            return PlaylistCard(playlist: playlist);
          },
        ),
      ),
    );
  }
}

class PlaylistCard extends StatelessWidget {
  const PlaylistCard({super.key, required this.playlist});

  final _PlaylistData playlist;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: playlist.coverColor,
              borderRadius: BorderRadius.circular(16),
              image: playlist.coverImage != null
                  ? DecorationImage(
                      image: FileImage(playlist.coverImage!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: playlist.coverImage == null
                ? const Icon(Icons.music_note, color: Colors.white70, size: 40)
                : null,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          playlist.title,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class _PlaylistData {
  const _PlaylistData({
    required this.title,
    this.coverColor = Colors.blue,
    this.coverImage,
  });

  final String title;
  final Color coverColor;
  final File? coverImage;
}
