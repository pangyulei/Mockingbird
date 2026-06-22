import 'dart:async';

import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:mockingbird/tab_player/player/sentence_card/sentence_card_interface_ui_events.dart';
import 'package:mockingbird/tab_player/player/sentence_card/sentence_card_widget.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:video_player/video_player.dart';
import '../../tool/global_broadcaster.dart';
import 'player_state.dart';
import 'player_logic.dart';

const double _kPlayerControlBarHeight = 36;
const double _kPlayerControlBarButtonWidth = 40;

class PlayerWidget extends StatefulWidget {
  final PlayerLogic _logic;
  const PlayerWidget(this._logic, {super.key});

  @override
  State<PlayerWidget> createState() => _WidgetFactory();
}

class _WidgetFactory extends State<PlayerWidget> implements SentenceCardInterfaceUIEvents {
  PlayerState _state = const PlayerState(showEmpty: true, showLoading: false);
  final _subs = <StreamSubscription>[];

  @override
  void initState() {
    super.initState();
    _subs.add(GlobalBroadcaster.instance.on<GlobalEventPlayMedia>((event) {
      _updateStateByStream(widget._logic.playerPlayMedia(_state, event.media));
    }));
  }

  @override
  void dispose() {
    for (final sub in _subs) {
      sub.cancel();
    }
    _state.videoController?.dispose();
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
          _playerPage(),
          if (_state.showLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }

  Widget _playerEmpty() {
    //TODO make it a real empty shit
    return Scaffold(
      appBar: AppBar(title: const Text('No title')),
      body: const Center(child: Text('No media selected'),),
    );
  }

  Widget _playerPage() {
    assert(!_state.showEmpty, 'showEmpty should be false');
    assert(_state.videoController != null, 'videoController should not be null');
    return Column(
        children: [
          AspectRatio(
              aspectRatio: _state.videoController!.value.aspectRatio,
              child: VideoPlayer(_state.videoController!)
          ),
          _playerControlBar(),
          _sentencesList(),
        ]
    );
  }

  Widget _sentencesList() {
    return Expanded(
      child: ScrollablePositionedList.builder(
        itemCount: _state.sentenceStates.length,
        itemScrollController: widget._logic.playerScrollController,
        itemBuilder: (context, index) {
          final sentenceState = _state.sentenceStates[index];
          return SentenceCardWidget(
              state: sentenceState.copyWith(isPlaying: index==_state.playingSentenceIndex),
              logic: this
          );
        },
      ),
    );
  }

  Widget _playerControlBar() {
    final videoController = _state.videoController!;
    final isPlaying = videoController.value.isPlaying;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: SizedBox(
        width: double.infinity,
        height: _kPlayerControlBarHeight,
        child: Row(
            spacing: 4,
            children: [
              // _playerButton((){}, const Icon(Icons.skip_previous)),
              // _playerButton((){}, const Icon(Icons.replay)),
              _playerButton((){
                setState(() {
                  if (isPlaying) {
                    videoController.pause();
                  } else {
                    videoController.play();
                  }
                });
              }, Icon(isPlaying ? Icons.pause_circle : Icons.play_circle)),
              // _playerButton((){}, Transform.flip(flipX: true, child: const Icon(Icons.replay))),
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
    if (newState.videoController != _state.videoController) {
      newState.videoController?.addListener(() => _onPlayerTimelinePositionChanged(newState.videoController!));
    }
    setState(() {
      _state = newState;
    });
  }

  void _onPlayerTimelinePositionChanged(VideoPlayerController videoController) {
    //TODO here should judge by preference
    //auto scroll subtitle sentences
    _updateState(widget._logic.playerPositionChanged(_state, videoController.value.position));
  }

  @override
  void sentenceCardClicked(int index) {
    _updateState(widget._logic.playerPlaySentence(_state, index));
  }
}
