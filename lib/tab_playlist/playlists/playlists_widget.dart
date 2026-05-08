import 'package:flutter/material.dart';

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
      appBar: AppBar(title: const Text('Playlists')),
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
            ),
            child: const Icon(
              Icons.music_note,
              color: Colors.white70,
              size: 40,
            ),
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
  const _PlaylistData({required this.title, required this.coverColor});

  final String title;
  final Color coverColor;
}
