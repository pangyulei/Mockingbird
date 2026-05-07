import 'package:flutter/material.dart';

class PlaylistsWidget extends StatefulWidget {
  const PlaylistsWidget({super.key});

  @override
  State<PlaylistsWidget> createState() => _PlaylistsWidgetFactory();
}

class _PlaylistsWidgetFactory extends State<PlaylistsWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Playlists')),
      body: const Center(child: Text('Playlists')),
    );
  }
}
