import 'dart:io';

import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    if (_state.showLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_state.playlist == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Playlist not found')),
        body: const Center(child: Text('Playlist not found')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_state.playlist!.name),
        actions: const [IconButton(icon: Icon(Icons.add), onPressed: null)],
      ),
      body: Column(
        children: [
          if (_state.playlist!.cover != null)
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: FileImage(File(_state.playlist!.cover!)),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          const Expanded(
            child: Center(child: Text('No songs yet. Tap + to add.')),
          ),
        ],
      ),
    );
  }
}
