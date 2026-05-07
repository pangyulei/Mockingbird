import 'package:flutter/material.dart';

class PlaylistWidget extends StatefulWidget {
  final String name;
  const PlaylistWidget(this.name, {super.key});

  @override
  State<PlaylistWidget> createState() => _PlaylistWidgetFactory();
}

class _PlaylistWidgetFactory extends State<PlaylistWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.name)),
      body: const Center(child: Text('Playlist')),
    );
  }
}
