import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:mockingbird/tab_player/player/player_state.dart';
import 'package:mockingbird/tab_player/player/sentence_card/sentence_card_ui.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:video_player/video_player.dart';

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

  void player_onGoToAlbums();
}

class PlayerUI extends StatelessWidget {
  final PlayerState _state;
  final PlayerUIOutputITF _logic;
  final ItemScrollController _scrollController;
  final VideoPlayerController? _videoController;

  const PlayerUI(
    this._state,
    this._logic,
    this._scrollController,
    this._videoController, {
    super.key,
  });

  @override
  Widget build(BuildContext ctx) {
    final videoController = _videoController;
    return Stack(
      children: [
        if (videoController != null && !_state.showEmpty)
          _page(ctx, videoController),
        if (_state.showEmpty) _empty(ctx),
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
    final theme = Theme.of(ctx);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: _appBar(ctx),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.black,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.5),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                AspectRatio(
                  aspectRatio: videoController.value.aspectRatio,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      VideoPlayer(videoController),
                      // Custom gradient overlay for controls
                      Positioned.fill(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withValues(alpha: 0.4),
                                Colors.transparent,
                                Colors.transparent,
                                Colors.black.withValues(alpha: 0.6),
                              ],
                              stops: const [0.0, 0.2, 0.7, 1.0],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 8,
                        right: 8,
                        bottom: 0,
                        child: Row(
                          crossAxisAlignment: .end,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 8.5),
                                child: _videoSlider(ctx, videoController),
                              ),
                            ),
                            _volumeComponent(ctx),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                _controlBar(ctx, videoController),
              ],
            ),
          ),
          if (_state.sentenceStates.isNotEmpty)
            Expanded(
              child: ColoredBox(
                color: theme.scaffoldBackgroundColor,
                child: _sentencesList(),
              ),
            ),
        ],
      ),
      floatingActionButton: _floatingButtons(ctx),
    );
  }

  Widget? _floatingButtons(BuildContext ctx) {
    if (_state.sentenceStates.isEmpty) return null;
    final colorScheme = Theme.of(ctx).colorScheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton.small(
          heroTag: 'scroll_top',
          onPressed: _logic.player_onScrollToTop,
          backgroundColor: colorScheme.surfaceContainerHighest,
          foregroundColor: colorScheme.primary,
          child: const Icon(Icons.keyboard_arrow_up_rounded),
        ),
        const SizedBox(height: 8),
        FloatingActionButton.small(
          heroTag: 'scroll_focus',
          onPressed: _logic.player_onScrollToFocusedSentence,
          child: const Icon(Icons.center_focus_strong_rounded),
        ),
        const SizedBox(height: 8),
        FloatingActionButton.small(
          heroTag: 'scroll_bottom',
          onPressed: _logic.player_onScrollToBottom,
          backgroundColor: colorScheme.surfaceContainerHighest,
          foregroundColor: colorScheme.primary,
          child: const Icon(Icons.keyboard_arrow_down_rounded),
        ),
      ],
    );
  }

  Widget _volumeComponent(BuildContext ctx) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_state.showVolumeSlider)
          SizedBox(height: 100, child: _volumeSlider(ctx)),
        IconButton(
          onPressed: _logic.player_onVolumeTap,
          icon: Icon(
            _state.volume == 0
                ? Icons.volume_off_rounded
                : Icons.volume_up_rounded,
          ),
          color: Colors.white,
          iconSize: 20,
        ),
      ],
    );
  }

  Widget _volumeSlider(BuildContext ctx) {
    final colorScheme = Theme.of(ctx).colorScheme;
    return RotatedBox(
      quarterTurns: 3,
      child: SliderTheme(
        data: SliderTheme.of(ctx).copyWith(
          trackHeight: 3.0,
          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6.0),
          overlayShape: const RoundSliderOverlayShape(overlayRadius: 12.0),
          activeTrackColor: colorScheme.primary,
          inactiveTrackColor: Colors.white24,
          thumbColor: Colors.white,
        ),
        child: Slider(
          value: _state.volume,
          onChanged: _logic.player_onVolumeChanging,
        ),
      ),
    );
  }

  Widget _videoSlider(BuildContext ctx, VideoPlayerController videoController) {
    final colorScheme = Theme.of(ctx).colorScheme;
    return ValueListenableBuilder(
      valueListenable: videoController,
      builder: (ctx, videoValue, child) {
        final int position = videoValue.position.inMicroseconds;
        final int duration = videoValue.duration.inMicroseconds;
        final draggingValue = _state.videoSliderDraggingValue;
        return SliderTheme(
          data: SliderTheme.of(ctx).copyWith(
            trackHeight: 4.0,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8.0),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 16.0),
            activeTrackColor: colorScheme.primary,
            inactiveTrackColor: Colors.white24,
            thumbColor: Colors.white,
          ),
          child: Slider(
            value: draggingValue ?? position.clamp(0, duration).toDouble(),
            min: 0.0,
            max: duration.toDouble(),
            onChangeStart: _logic.player_onVideoSliderStartChanged,
            onChangeEnd: _logic.player_onVideoSliderEndChanged,
            onChanged: _logic.player_onVideoSliderChanging,
          ),
        );
      },
    );
  }

  Widget _empty(BuildContext ctx) {
    final colorScheme = Theme.of(ctx).colorScheme;
    final textTheme = Theme.of(ctx).textTheme;
    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer.withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.auto_stories_rounded,
                  size: 80,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(height: 40),
              Text(
                'Ready to Shadow?',
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Shadowing is the key to mastering a new language. Select a media from your albums to begin your practice session.',
                textAlign: TextAlign.center,
                style: textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 48),
              Text(
                'Your progress starts here.',
                style: textTheme.labelLarge?.copyWith(
                  color: colorScheme.primary.withValues(alpha: 0.7),
                  letterSpacing: 2,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 32),
              FilledButton.icon(
                onPressed: _logic.player_onGoToAlbums,
                icon: const Icon(Icons.library_music_rounded),
                label: const Text('Go to Albums'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sentencesList() {
    return ScrollablePositionedList.builder(
      itemCount: _state.sentenceStates.length,
      itemScrollController: _scrollController,
      itemBuilder: (context, index) {
        final sentenceState = _state.sentenceStates[index];
        return SentenceCardUI(index, sentenceState, _logic);
      },
    );
  }

  AppBar _appBar(BuildContext ctx) {
    return AppBar(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      automaticallyImplyLeading: false,
      // leading: IconButton(
      //   icon: const Icon(Icons.arrow_back_ios_new_rounded),
      //   onPressed: () => Navigator.of(ctx).pop(),
      // ),
      title: _title(),
    );
  }

  Widget _title() {
    final text = _state.title.trim();
    if (text.isEmpty) {
      return const Text('');
    }
    return SizedBox(
      height: 24,
      child: Marquee(
        text: text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        scrollAxis: Axis.horizontal,
        blankSpace: 50,
        velocity: 30,
      ),
    );
  }

  Widget _controlBar(BuildContext ctx, VideoPlayerController videoController) {
    final colorScheme = Theme.of(ctx).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          bottom: BorderSide(color: colorScheme.primary.withValues(alpha: 0.3)),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        children: [
          _playOrPauseButton(ctx, videoController),
          const SizedBox(width: 16),
          if (_state.sentenceStates.isNotEmpty) _repeatOneButton(ctx),
          const Spacer(),
          _speedDownButton(ctx),
          const SizedBox(width: 8),
          _speedLabel(ctx),
          const SizedBox(width: 8),
          _speedUpButton(ctx),
        ],
      ),
    );
  }

  Widget _playOrPauseButton(
    BuildContext ctx,
    VideoPlayerController videoController,
  ) {
    final isPlaying = _state.isPlaying;
    final colorScheme = Theme.of(ctx).colorScheme;
    return IconButton.filled(
      onPressed: () {
        if (isPlaying) {
          _logic.player_onPause();
        } else {
          _logic.player_onPlay();
        }
      },
      icon: Icon(
        isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
        size: 24,
      ),
      style: IconButton.styleFrom(
        backgroundColor: colorScheme.primary,
        foregroundColor: Colors.white,
        tapTargetSize: .shrinkWrap,
      ),
      constraints: const BoxConstraints(minWidth: 30, minHeight: 30),
      padding: EdgeInsets.zero,
    );
  }

  Widget _repeatOneButton(BuildContext ctx) {
    final colorScheme = Theme.of(ctx).colorScheme;
    return IconButton(
      onPressed: () {
        if (_state.repeat) {
          _logic.player_onRepeatOne();
        } else {
          _logic.player_onInOrder();
        }
      },
      icon: Icon(
        _state.repeat ? Icons.repeat_one_rounded : Icons.repeat_rounded,
        color: _state.repeat ? colorScheme.primary : colorScheme.outline,
      ),
      style: IconButton.styleFrom(tapTargetSize: .shrinkWrap),
      constraints: const BoxConstraints(minWidth: 30, minHeight: 30),
      padding: EdgeInsets.zero,
    );
  }

  Widget _speedDownButton(BuildContext ctx) {
    return IconButton(
      onPressed: _logic.player_onSpeedDown,
      icon: const Icon(Icons.remove_circle_outline_rounded),
      color: Theme.of(ctx).colorScheme.outline,
      style: IconButton.styleFrom(tapTargetSize: .shrinkWrap),
      constraints: const BoxConstraints(minWidth: 30, minHeight: 30),
      padding: EdgeInsets.zero,
    );
  }

  Widget _speedUpButton(BuildContext ctx) {
    return IconButton(
      onPressed: _logic.player_onSpeedUp,
      icon: const Icon(Icons.add_circle_outline_rounded),
      color: Theme.of(ctx).colorScheme.outline,
      style: IconButton.styleFrom(tapTargetSize: .shrinkWrap),
      constraints: const BoxConstraints(minWidth: 30, minHeight: 30),
      padding: EdgeInsets.zero,
    );
  }

  Widget _speedLabel(BuildContext ctx) {
    final colorScheme = Theme.of(ctx).colorScheme;
    return GestureDetector(
      onTap: _logic.player_onSpeedReset,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: colorScheme.primaryContainer.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          '${_state.speed}x',
          style: TextStyle(
            color: colorScheme.primary,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  // Widget _controlButton(
  //   void Function() onPressed,
  //   Widget icon,
  // ) {
  //   return SizedBox(
  //     width: _kPlayerControlBarButtonWidth,
  //     child: IconButton.filledTonal(
  //       onPressed: onPressed,
  //       icon: icon,
  //       padding: EdgeInsets.zero,
  //     ),
  //   );
  // }
}
