import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mockingbird/global_broadcaster/global_broadcaster.dart';
import 'package:mockingbird/global_broadcaster/global_events.dart';
import 'package:video_player/video_player.dart';
import '../../models/track.dart';
import 'player_state.dart';
import 'player_logic.dart';

class PlayerWidget extends StatefulWidget {
  final PlayerLogic _logic;
  const PlayerWidget(this._logic, {super.key});

  @override
  State<PlayerWidget> createState() => _PlayerWidgetFactory();
}

class _PlayerWidgetFactory extends State<PlayerWidget> {
  PlayerState _state = const PlayerState(showLoading: false);
  final List<StreamSubscription> _subs = [];

  @override
  void initState() {
    super.initState();
    _subs.add(GlobalBroadcaster.instance.on<GlobalEventPlayTrack>((event) {
      _updateStateByStream(widget._logic.playerPlayTrack(_state, event.track));
    }));
  }

  @override
  void dispose() {
    for (final sub in _subs) {
      sub.cancel();
    }
    _state.playerController?.dispose();
    super.dispose();
  }

  void _updateStateByStream(Stream<PlayerState> stream) async {
    await for (final newState in stream) {
      _updateState(newState);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_state.track == null ||
        _state.playerController == null ||
        !_state.playerController!.value.isInitialized) {
      return const _PlayerEmptyWidget();
    }
    Track track = _state.track!;
    VideoPlayerController playerController = _state.playerController!;
    return Scaffold(
      appBar: AppBar(
        title: Text(track.name),
      ),
      body: _state.showLoading ? const Center(child: CircularProgressIndicator()):
      Column(
          children: [
            AspectRatio(
                aspectRatio: playerController.value.aspectRatio,
                child: VideoPlayer(playerController)
            )
          ]
      ),
    );
  }

  void _updateState(PlayerState newState) {
    setState(() {
      _state = newState;
    });
  }
}

class _PlayerEmptyWidget extends StatelessWidget {
  const _PlayerEmptyWidget();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('no track to play')),
      body: const Center(child: Text('go select a track'),),
    );
  }
}
