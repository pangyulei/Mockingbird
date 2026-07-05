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
  void player_onSpeedReset();
  void player_onVideoSliderStartChanged(double microValue);
  void player_onVideoSliderEndChanged(double microValue);
  void player_onVideoSliderChanging(double microValue);
  void player_onScrollToFocusedSentence();
  void player_onScrollToTop();
  void player_onScrollToBottom();
  void player_onVolumeChanging(double newVolume);
  void player_onVolumeTap();
}

class PlayerUI extends StatelessWidget {
  final PlayerState _state;
  final PlayerUIOutputITF _logic;
  final ItemScrollController _scrollController;

  const PlayerUI(this._state, this._logic, this._scrollController, {super.key});

  @override
  Widget build(BuildContext ctx) {
    final videoController = _state.videoController;
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
          Stack(
            children: [
              AspectRatio(
                aspectRatio: videoController.value.aspectRatio,
                child: VideoPlayer(videoController),
              ),
              Positioned.fill(
                left: 8,
                top: 8,
                bottom: 0,
                right: 0,
                child: Row(
                  crossAxisAlignment: .end,
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 44,
                        child: _videoSlider(videoController),
                      ),
                    ),
                    _volumeComponent(ctx, videoController),
                  ],
                ),
              ),
            ],
          ),
          _controlBar(ctx, videoController),
          if (_state.sentenceStates.isNotEmpty) _sentencesList(),
        ],
      ),
      floatingActionButton: _floatingButtons(),
    );
  }

  Widget? _floatingButtons() {
    if (_state.sentenceStates.isEmpty) return null;
    return Column(
      mainAxisAlignment: .end,
      children: [
        FloatingActionButton.small(
          onPressed: _logic.player_onScrollToTop,
          child: const Icon(Icons.vertical_align_top),
        ),
        FloatingActionButton.small(
          onPressed: _logic.player_onScrollToFocusedSentence,
          child: const Icon(Icons.my_location),
        ),
        FloatingActionButton.small(
          onPressed: _logic.player_onScrollToBottom,
          child: const Icon(Icons.vertical_align_bottom),
        ),
      ],
    );
  }

  Widget _volumeComponent(
    BuildContext ctx,
    VideoPlayerController videoController,
  ) {
    return Column(
      mainAxisAlignment: .end,
      children: [
        if (_state.showVolumeSlider)
          Expanded(child: _volumeSlider(ctx, videoController)),
        IconButton(
          onPressed: _logic.player_onVolumeTap,
          icon: const Icon(Icons.volume_up),
          iconSize: 24,
          style: const ButtonStyle(tapTargetSize: .shrinkWrap),
          constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
          padding: EdgeInsets.zero,
        ),
      ],
    );
  }

  Widget _volumeSlider(
    BuildContext ctx,
    VideoPlayerController videoController,
  ) {
    return RotatedBox(
      quarterTurns: 3,
      child: SliderTheme(
        data: SliderTheme.of(ctx).copyWith(
          // 1. 縮小軌道高度
          trackHeight: 2.0,
          // 2. 移除周圍的滑塊內邊距（關鍵：將熱區半徑縮小或設為與滑塊相同）
          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8.0),
          overlayShape: const RoundSliderOverlayShape(overlayRadius: 12.0),
          // 3. 移除滑塊在兩端的空白間距
          valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
        ),
        child: Slider(
          value: videoController.value.volume,
          min: 0.0,
          max: 1.0,
          divisions: 10, //cut 1 into step 0.1
          activeColor: Theme.of(ctx).colorScheme.primary,
          thumbColor: Theme.of(ctx).colorScheme.primary,
          inactiveColor: Theme.of(
            ctx,
          ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
          onChanged: (newVolume) {
            _logic.player_onVolumeChanging(newVolume);
          },
        ),
      ),
    );
  }

  Widget _videoSlider(VideoPlayerController videoController) {
    return ValueListenableBuilder(
      valueListenable: videoController,
      builder: (ctx, videoValue, child) {
        final int position = videoValue.position.inMicroseconds;
        final int duration = videoValue.duration.inMicroseconds;
        final draggingValue = _state.videoSliderDraggingValue;
        return SliderTheme(
          data: SliderTheme.of(ctx).copyWith(
            // 1. 縮小軌道高度
            trackHeight: 4.0,
            // 2. 移除周圍的滑塊內邊距（關鍵：將熱區半徑縮小或設為與滑塊相同）
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8.0),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 12.0),
            // 3. 移除滑塊在兩端的空白間距
            valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
          ),
          child: Slider(
            value: draggingValue ?? position.clamp(0, duration).toDouble(),
            min: 0.0,
            max: duration.toDouble(),
            activeColor: Theme.of(ctx).colorScheme.primary,
            thumbColor: Theme.of(ctx).colorScheme.primary,
            inactiveColor: Theme.of(
              ctx,
            ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
            onChangeStart: (sliderValue) {
              _logic.player_onVideoSliderStartChanged(sliderValue);
            },
            onChangeEnd: (sliderValue) {
              _logic.player_onVideoSliderEndChanged(sliderValue);
            },
            onChanged: (sliderValue) {
              _logic.player_onVideoSliderChanging(sliderValue);
            },
          ),
        );
      },
    );
  }

  Widget _empty() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('No title'),
        automaticallyImplyLeading: false,
        // centerTitle: true,
      ),
      body: const Center(child: Text('No media selected')),
    );
  }

  Widget _sentencesList() {
    return Expanded(
      child: ScrollablePositionedList.builder(
        itemCount: _state.sentenceStates.length,
        itemScrollController: _scrollController,
        itemBuilder: (context, index) {
          final sentenceState = _state.sentenceStates[index];
          return SentenceCardUI(
            sentenceState.copyWith(isFocused: index == _state.focusedIndex),
            _logic,
          );
        },
      ),
    );
  }

  Widget _controlBar(BuildContext ctx, VideoPlayerController videoController) {
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
            _playOrPauseButton(videoController),
            // _playerButton((){}, Transform.flip(flipX: true, child: const Icon(Icons.replay))),
            // _playerButton((){}, const Icon(Icons.skip_next)),
            const Spacer(),
            if (_state.sentenceStates.isNotEmpty) _repeatOneButton(),
            _speedDownButton(),
            _speedLabel(ctx, videoController),
            _speedUpButton(),
          ],
        ),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      automaticallyImplyLeading: false,
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

  Widget _playOrPauseButton(VideoPlayerController videoController) {
    final isPlaying = videoController.value.isPlaying;
    return _controlButton(() {
      if (isPlaying) {
        _logic.player_onPause();
      } else {
        _logic.player_onPlay();
      }
    }, Icon(isPlaying ? Icons.pause_circle : Icons.play_circle));
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

  Widget _speedLabel(BuildContext ctx, VideoPlayerController videoController) {
    return SizedBox(
      // 1. Set explicit outer dimensions
      height: _kPlayerControlBarHeight,
      child: TextButton(
        style: TextButton.styleFrom(
          // 1. Define the inner padding (This directly dictates the extra width)
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),

          // 2. Set minimumSize to 0 so it doesn't enforce a default minimum width
          minimumSize: Size.zero,

          // 3. Keep visual bounds tight to the child
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,

          backgroundColor: Colors.blue,
          foregroundColor: Theme.of(ctx).colorScheme.primaryContainer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        onPressed: _logic.player_onSpeedReset,
        child: Text(
          '${videoController.value.playbackSpeed.toString()}x', // The button width will perfectly match this text + 30px padding on each side
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
    // return Container(
    //   height: _kPlayerControlBarHeight,
    //   alignment: .center,
    //   padding: const EdgeInsets.symmetric(
    //     vertical: 0,
    //     horizontal: 8,
    //   ), // 1. Padding inside the box
    //   decoration: BoxDecoration(
    //     color: Theme.of(ctx).colorScheme.primaryContainer, // 2. Box Color
    //     borderRadius: BorderRadius.circular(8.0), // 3. Rounded corners
    //   ),
    //   child: Text(
    //     '${_state.speed.toString()}x',
    //     style: const TextStyle(fontWeight: FontWeight.bold),
    //   ),
    // );
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
