import 'dart:async';

import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:mockingbird/global_broadcaster/global_broadcaster.dart';
import 'package:mockingbird/global_broadcaster/global_events.dart';
import 'package:mockingbird/tab_player/player_sentence/player_sentence_widget.dart';
import 'package:video_player/video_player.dart';
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
    if (_state.showEmpty) {
      return _playerEmpty();
    }
    return Scaffold(
      appBar: _appBar(),
      body: Stack(
        children: [
          if (_state.showLoading) const Center(child: CircularProgressIndicator()),
          _playerPage(),
        ],
      ),
    );
  }

  Widget _playerEmpty() {
    return Scaffold(
      appBar: AppBar(title: const Text('no track to play')),
      body: const Center(child: Text('go select a track'),),
    );
  }

  Widget _playerPage() {
    return Column(
        children: [
          AspectRatio(
              aspectRatio: _state.playerController!.value.aspectRatio,
              child: VideoPlayer(_state.playerController!)
          ),
          _playerControlBar(),
          _sentencesList(),
        ]
    );
  }

  Widget _sentencesList() {
    return Expanded(
      child: ListView.builder(
        itemCount: _state.sentences.length,
        itemBuilder: (context, index) {
          final sentence = _state.sentences[index];
          return PlayerSentenceWidget(
            sentence: sentence,
            isSelected: _state.currentSentenceIndex == index,
            onTap: () {
              _state.playerController?.seekTo(sentence.start);
              _state.playerController?.play();
            },
          );
        },
      ),
    );
  }

  Widget _playerControlBar() {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: SizedBox(
        width: double.infinity,
        height: _kPlayerControlBarHeight,
        child: Row(
            spacing: 4,
            children: [
              // _playerButton((){}, const Icon(Icons.skip_previous)),
              _playerButton((){}, const Icon(Icons.replay)),
              _playerButton((){}, const Icon(Icons.play_circle)),
              _playerButton((){}, Transform.flip(flipX: true, child: const Icon(Icons.replay))),
              // _playerButton((){}, const Icon(Icons.skip_next)),
              const Spacer(),
              _playerButton((){}, const Icon(Icons.repeat_one)),
              _playerSpeedButton(),
            ]
        ),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: SizedBox(
        width: double.infinity,
        height: kToolbarHeight,
        child: Marquee(
          text: _state.title!,
          scrollAxis: Axis.horizontal,
          blankSpace: 50,
          velocity: 30,
          pauseAfterRound: Duration.zero,
          accelerationDuration: Duration.zero,
          decelerationDuration: Duration.zero,
        ),
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
    if (newState.playerController != _state.playerController) {
      _state.playerController?.removeListener(_onPlayerControllerUpdate);
      newState.playerController?.addListener(_onPlayerControllerUpdate);
    }
    setState(() {
      _state = newState;
    });
  }

  void _onPlayerControllerUpdate() {
    if (_state.playerController == null) return;
    final newState = widget._logic.playerUpdatePosition(
      _state,
      _state.playerController!.value.position,
    );
    if (newState != _state) {
      _updateState(newState);
    }
  }
}
