import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:mockingbird/tab_player/player/player_state.dart';
import 'package:mockingbird/tab_player/player/sentence_card/sentence_card_ui.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:video_player/video_player.dart';

const double _kPlayerControlBarHeight = 36;
const double _kPlayerControlBarButtonWidth = 40;

abstract interface class PlayerUIOutputITF implements SentenceCardUIOutputITF {
  void player_onPlay();
  void player_onPause();
  void player_onRepeatOne();
  void player_onInOrder();
  void player_onSpeedUp();
  void player_onSpeedDown();
}

class PlayerUI extends StatelessWidget {
  final PlayerState _state;
  final PlayerUIOutputITF _logic;
  final VideoPlayerController? _videoController;
  final ItemScrollController _scrollController;
  const PlayerUI(
    this._state,
    this._logic,
    this._videoController,
    this._scrollController, {
    super.key,
  });

  @override
  Widget build(BuildContext ctx) {
    final videoController = _videoController;
    return Stack(
      children: [
        if (videoController != null) _page(ctx, videoController),
        if (_state.showEmpty) _empty(),
        if (_state.showLoading) _loading(),
      ],
    );
  }

  Widget _loading() {
    return ColoredBox(
      color: Colors.black.withAlpha(20),
      child: const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _page(BuildContext ctx, VideoPlayerController videoController) {
    return Scaffold(
      appBar: _appBar(),
      body: Column(
        children: [
          AspectRatio(
            aspectRatio: videoController.value.aspectRatio,
            child: VideoPlayer(videoController),
          ),
          _playerControlBar(ctx),
          if (_state.sentenceStates.isNotEmpty) _sentencesList(),
        ],
      ),
    );
  }

  Widget _empty() {
    //TODO make it a real empty shit
    return Scaffold(
      appBar: AppBar(title: const Text('No title')),
      body: const Center(child: Text('No media selected')),
    );
  }

  Widget _sentencesList() {
    assert(
      _state.sentenceStates.isNotEmpty,
      'empty subtitle should not show sentences list',
    );
    return Expanded(
      child: ScrollablePositionedList.builder(
        itemCount: _state.sentenceStates.length,
        itemScrollController: _scrollController,
        itemBuilder: (context, index) {
          final sentenceState = _state.sentenceStates[index];
          return SentenceCardUI(
            sentenceState.copyWith(isHighlighted: index == _state.focusedIndex),
            _logic,
          );
        },
      ),
    );
  }

  Widget _playerControlBar(BuildContext ctx) {
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
            _playOrPauseButton(),
            // _playerButton((){}, Transform.flip(flipX: true, child: const Icon(Icons.replay))),
            // _playerButton((){}, const Icon(Icons.skip_next)),
            const Spacer(),
            if (_state.sentenceStates.isNotEmpty) _repeatOneButton(),
            _speedDownButton(),
            _speedLabel(ctx),
            _speedUpButton(),
          ],
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
          text: _state.title,
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

  Widget _playOrPauseButton() {
    return _controlButton(() {
      if (_state.isPlaying) {
        _logic.player_onPlay();
      } else {
        _logic.player_onPause();
      }
    }, Icon(_state.isPlaying ? Icons.pause_circle : Icons.play_circle));
  }

  Widget _repeatOneButton() {
    return _controlButton(() {
      if (_state.repeatIndex == null) {
        _logic.player_onInOrder();
      } else {
        _logic.player_onRepeatOne();
      }
    }, Icon(_state.repeatIndex != null ? Icons.repeat_one : Icons.repeat));
  }

  Widget _speedDownButton() {
    return _controlButton(() {
      _logic.player_onSpeedDown();

    }, const Icon(Icons.fast_rewind));
  }

  Widget _speedUpButton() {
    return _controlButton(() {
      _logic.player_onSpeedUp();

    }, const Icon(Icons.fast_forward));
  }

  Widget _speedLabel(BuildContext ctx) {
    return Container(
      height: _kPlayerControlBarHeight,
      alignment: .center,
      padding: const EdgeInsets.symmetric(
        vertical: 0,
        horizontal: 8,
      ), // 1. Padding inside the box
      decoration: BoxDecoration(
        color: Theme.of(ctx).colorScheme.primaryContainer, // 2. Box Color
        borderRadius: BorderRadius.circular(8.0), // 3. Rounded corners
      ),
      child: Text(
        '${_state.speed.toString()}x',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _controlButton(void Function() onPressed, Widget icon) {
    return SizedBox(
      width: _kPlayerControlBarButtonWidth,
      child: IconButton.filledTonal(
        onPressed: onPressed,
        icon: icon,
        padding: EdgeInsets.zero,
      ),
    );
  }
}
