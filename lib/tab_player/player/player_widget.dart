import 'dart:async';

import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:mockingbird/global_broadcaster/global_broadcaster.dart';
import 'package:mockingbird/global_broadcaster/global_events.dart';
import 'package:video_player/video_player.dart';
import '../../models/track.dart';
import 'player_state.dart';
import 'player_logic.dart';

const double _kPlayerControlBarHeight = 36;
const double _kPlayerControlBarButtonWidth = 40;

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
        title: SizedBox(
          width: double.infinity,
          height: kToolbarHeight,
          child: Marquee(
            text: track.name,
            scrollAxis: Axis.horizontal,
            blankSpace: 50,
            velocity: 30,
            pauseAfterRound: Duration.zero,
            accelerationDuration: Duration.zero,
            decelerationDuration: Duration.zero,
          ),
        ),
      ),
      body: _state.showLoading ? const Center(child: CircularProgressIndicator()):
      Column(
          children: [
            AspectRatio(
                aspectRatio: playerController.value.aspectRatio,
                child: VideoPlayer(playerController)
            ),
            Padding(
              padding: const EdgeInsets.all(4),
              child: SizedBox(
                width: double.infinity,
                height: _kPlayerControlBarHeight,
                child: Row(
                  spacing: 4,
                  children: [
                    _playerButton((){}, const Icon(Icons.skip_previous)),
                    _playerButton((){}, const Icon(Icons.replay)),
                    _playerButton((){}, const Icon(Icons.play_circle)),
                    _playerButton((){}, Transform.flip(flipX: true, child: const Icon(Icons.replay))),
                    _playerButton((){}, const Icon(Icons.skip_next)),
                    const Spacer(),
                    _playerButton((){}, const Icon(Icons.repeat_one)),
                    _playerSpeedButton(),
                  ]
                ),
              ),
            ),
          ]
      ),
    );
  }

  Widget _playerSpeedButton() {
    return FilledButton.tonal(
      onPressed: (){},
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromWidth(_kPlayerControlBarButtonWidth),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
        ),
      ),
      child: const Text('2.25x', style: TextStyle(
        fontWeight: FontWeight.bold,
      ),),
    );
  }

  Widget _playerButton(void Function() onPressed, Widget icon) {
    return SizedBox(
      width: _kPlayerControlBarButtonWidth,
      child: IconButton.filledTonal(
        onPressed: onPressed,
        icon: icon,
        padding: EdgeInsets.zero,
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
