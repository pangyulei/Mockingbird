import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marquee/marquee.dart';
import 'package:mockingbird/tab_player/player/player_provider.dart';
import 'package:mockingbird/tab_player/player/sentence_card/sentence_card_ui.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:video_player/video_player.dart';

class PlayerUI extends ConsumerWidget {
  const PlayerUI({super.key});

  @override
  Widget build(BuildContext ctx, WidgetRef ref) {
    return Stack(children: [_page(ctx), _empty()]);
  }

  void _onAddSubtitle(WidgetRef ref) async {
    await ref.read(playerProvider.notifier).addSubtitle();
  }

  void _onUnloop(WidgetRef ref) {
    ref.read(playerProvider.notifier).loop();
  }

  void _onLoop(WidgetRef ref) {
    ref.read(playerProvider.notifier).unloop();
  }

  void _onPause(WidgetRef ref) async {
    await ref.read(playerProvider.notifier).pause();
  }

  void _onPlay(WidgetRef ref) async {
    await ref.read(playerProvider.notifier).play();
  }

  void _onDecSpeed(WidgetRef ref) async {
    await ref.read(playerProvider.notifier).decSpeed();
  }

  void _onIncSpeed(WidgetRef ref) async {
    await ref.read(playerProvider.notifier).incSpeed();
  }

  void _onResetSpeed(WidgetRef ref) async {
    await ref.read(playerProvider.notifier).resetSpeed();
  }

  void _onVideoPositionChanged(WidgetRef ref, VideoPlayerController videoController) async {
    await ref.read(playerProvider.notifier).videoPositionChanged(videoController);
  }

  void _onVideoSliderStartChanged(WidgetRef ref, double valMicro) async {
    await ref.read(playerProvider.notifier).videoSliderStartChanged(valMicro);
  }

  void _onVideoSliderChanging(WidgetRef ref, double valMicro) async {
    await ref.read(playerProvider.notifier).videoSliderChanging(valMicro);
  }

  void _onVideoSliderEndChanged(WidgetRef ref, double valMicro) async {
    await ref.read(playerProvider.notifier).videoSliderEndChanged(valMicro);
  }

  void _onScrollToFocusedSentence() {
    // final focusedIndex = _state.focusedIndex;
    // if (focusedIndex != null &&
    //     focusedIndex >= 0 &&
    //     focusedIndex < _state.sentenceStates.length) {
    //   _scrollController._scrollTo(focusedIndex);
    // }
  }

  void _onScrollToTop() {
    // if (_state.sentenceStates.isEmpty) {
    //   debugPrint('no sentence list to scroll');
    //   return;
    // }
    // _scrollController._scrollTo(0);
  }

  void _onScrollToBottom() {
    // if (_state.sentenceStates.isEmpty) {
    //   debugPrint('no sentence list to scroll');
    //   return;
    // }
    // _scrollController._scrollTo(_state.sentenceStates.length - 1);
  }

  void _onVolumeChanged(WidgetRef ref, double newVolume) async {
    await ref.read(playerProvider.notifier).updateVolume(newVolume);
  }

  void _onVolumeTap(WidgetRef ref) {
    ref.read(playerProvider.notifier).volumeTapped();
  }

  void _onGoToAlbums() {
    // context.go(AppRoute.albums);
  }

  Widget _page(BuildContext ctx) {
    final theme = Theme.of(ctx);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: _appBar(),
      body: _body(ctx),
      floatingActionButton: _floatingButtons(),
    );
  }

  Widget _body(BuildContext ctx) {
    return Column(children: [_videoComponents(), _sentenceList(ctx)]);
  }

  Widget _videoComponents() {
    return Consumer(
      builder: (ctx, ref, child) {
        final videoController = ref.watch(
          playerProvider.select((st) => st?.videoState?.controller),
        );
        if (videoController == null) return const SizedBox.shrink();
        videoController.addListener(() => _onVideoPositionChanged(ref, videoController));
        return Container(
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
              _displayer(ctx, ref, videoController),
              _controlBar(ctx, ref, videoController),
            ],
          ),
        );
      },
    );
  }

  Widget _displayer(BuildContext ctx, WidgetRef ref, VideoPlayerController videoController) {
    return AspectRatio(
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
            top: 0,
            bottom: 0,
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  right: 48,
                  bottom: 8.5,
                  child: _videoSlider(ctx, videoController),
                ),
                Positioned(right: 0, bottom: 0, top: 0, child: _volumeComponent(ref)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sentenceList(BuildContext ctx) {
    return Expanded(
      child: ColoredBox(
        color: Theme.of(ctx).scaffoldBackgroundColor,
        child: Consumer(
          builder: (ctx, ref, child) {
            final sentenceCount = ref.watch(playerProvider.select((st) => st?.sentenceCount ?? 0));
            if (sentenceCount == 0) {
              return _noSubtitle(ctx, ref);
            }
            return Consumer(
              builder: (context, ref, child) {
                final scrollController = ref.watch(
                  playerProvider.select((st) => st?.scrollController),
                );
                return ScrollablePositionedList.builder(
                  itemCount: sentenceCount,
                  itemScrollController: scrollController,
                  itemBuilder: (context, i) {
                    final sentenceId = ref.read(playerProvider.notifier).sentenceIdAtIndex(i);
                    return SentenceCardUI(sentenceId);
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _noSubtitle(BuildContext ctx, WidgetRef ref) {
    final theme = Theme.of(ctx);
    final colorScheme = theme.colorScheme;
    return InkWell(
      onTap: () => _onAddSubtitle(ref),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.subtitles_off_rounded,
              size: 48,
              color: colorScheme.outline.withValues(alpha: 0.4),
            ),
            const SizedBox(height: 16),
            Text(
              'No Subtitles Found',
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.outline,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap here to import a subtitle file',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.outline.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget? _floatingButtons() {
    return Consumer(
      builder: (context, ref, child) {
        final sentenceCount = ref.watch(playerProvider.select((st) => st?.sentenceCount ?? 0));
        if (sentenceCount == 0) {
          return const SizedBox.shrink();
        } else {
          final colorScheme = Theme.of(context).colorScheme;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FloatingActionButton.small(
                heroTag: 'scroll_top',
                onPressed: _onScrollToTop,
                backgroundColor: colorScheme.surfaceContainerHighest,
                foregroundColor: colorScheme.primary,
                child: const Icon(Icons.keyboard_arrow_up_rounded),
              ),
              const SizedBox(height: 8),
              FloatingActionButton.small(
                heroTag: 'scroll_focus',
                onPressed: _onScrollToFocusedSentence,
                child: const Icon(Icons.center_focus_strong_rounded),
              ),
              const SizedBox(height: 8),
              FloatingActionButton.small(
                heroTag: 'scroll_bottom',
                onPressed: _onScrollToBottom,
                backgroundColor: colorScheme.surfaceContainerHighest,
                foregroundColor: colorScheme.primary,
                child: const Icon(Icons.keyboard_arrow_down_rounded),
              ),
            ],
          );
        }
      },
    );
  }

  Widget _volumeComponent(WidgetRef ref) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Consumer(
          builder: (ctx, ref, child) {
            final showVolumeSlider = ref.watch(
              playerProvider.select((st) => st?.videoState?.showVolumeSlider ?? false),
            );
            if (showVolumeSlider) {
              return Flexible(child: _volumeSlider(ctx));
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
        IconButton(
          onPressed: () => _onVolumeTap(ref),
          icon: Consumer(
            builder: (context, ref, child) {
              final volume = ref.watch(playerProvider.select((st) => st?.videoState?.volume ?? 1));
              final icon = volume == 0 ? Icons.volume_off_rounded : Icons.volume_up_rounded;
              return Icon(icon);
            },
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
        child: Consumer(
          builder: (context, ref, child) {
            final volume = ref.watch(playerProvider.select((st) => st?.videoState?.volume ?? 1));
            return Slider(
              value: volume,
              onChanged: (newVolume) => _onVolumeChanged(ref, newVolume),
            );
          },
        ),
      ),
    );
  }

  Widget _videoSlider(BuildContext ctx, VideoPlayerController videoController) {
    final colorScheme = Theme.of(ctx).colorScheme;
    return SliderTheme(
      data: SliderTheme.of(ctx).copyWith(
        trackHeight: 4.0,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8.0),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 16.0),
        activeTrackColor: colorScheme.primary,
        inactiveTrackColor: Colors.white24,
        thumbColor: Colors.white,
      ),
      child: Consumer(
        builder: (context, ref, child) {
          final position = ref.watch(
            playerProvider.select((st) => (st?.videoState?.positionMicro ?? 0).toDouble()),
          );
          final duration = videoController.value.duration.inMicroseconds.toDouble();
          // debugPrint('slider pos: ${position} pos.clamp: ${position.clamp(0, duration)}');
          // debugPrint('slider max: ${videoController.value.duration}');
          return Slider(
            value: position.clamp(0, duration),
            max: duration,
            onChangeStart: (val) => _onVideoSliderStartChanged(ref, val),
            onChanged: (val) => _onVideoSliderChanging(ref, val),
            onChangeEnd: (val) => _onVideoSliderEndChanged(ref, val),
            allowedInteraction: SliderInteraction.tapAndSlide,
          );
        },
      ),
    );
  }

  Widget _empty() {
    return Consumer(
      builder: (context, ref, child) {
        final st = ref.watch(playerProvider);
        if (st != null) return const SizedBox.shrink();

        final colorScheme = Theme.of(context).colorScheme;
        final textTheme = Theme.of(context).textTheme;
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
                    child: Icon(Icons.auto_stories_rounded, size: 80, color: colorScheme.primary),
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
                    onPressed: _onGoToAlbums,
                    icon: const Icon(Icons.library_music_rounded),
                    label: const Text('Go to Albums'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  AppBar _appBar() {
    return AppBar(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      automaticallyImplyLeading: false,
      title: _title(),
    );
  }

  Widget _title() {
    return SizedBox(
      height: 24,
      child: Consumer(
        builder: (ctx, ref, _) {
          final title = ref.watch(playerProvider.select((st) => st?.title ?? ''));
          if (title.isEmpty) {
            return const Text('');
          } else {
            return Marquee(
              text: title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              scrollAxis: Axis.horizontal,
              blankSpace: 50,
              velocity: 30,
            );
          }
        },
      ),
    );
  }

  Widget _controlBar(BuildContext ctx, WidgetRef ref, VideoPlayerController videoController) {
    final colorScheme = Theme.of(ctx).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(bottom: BorderSide(color: colorScheme.primary.withValues(alpha: 0.3))),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        children: [
          _playOrPauseButton(ctx),
          const SizedBox(width: 16),
          _loopButton(ctx),
          const Spacer(),
          _speedDownButton(ctx, ref),
          const SizedBox(width: 8),
          _speedLabel(ctx, ref),
          const SizedBox(width: 8),
          _speedUpButton(ctx, ref),
        ],
      ),
    );
  }

  Widget _playOrPauseButton(BuildContext ctx) {
    final colorScheme = Theme.of(ctx).colorScheme;
    return Consumer(
      builder: (ctx, ref, child) {
        final isPlaying = ref.watch(
          playerProvider.select((st) => st?.videoState?.isPlaying ?? false),
        );
        return IconButton.filled(
          onPressed: () {
            if (isPlaying) {
              _onPause(ref);
            } else {
              _onPlay(ref);
            }
          },
          icon: Icon(isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded, size: 24),
          style: IconButton.styleFrom(
            backgroundColor: colorScheme.primary,
            foregroundColor: Colors.white,
            tapTargetSize: .shrinkWrap,
          ),
          constraints: const BoxConstraints(minWidth: 30, minHeight: 30),
          padding: EdgeInsets.zero,
        );
      },
    );
  }

  Widget _loopButton(BuildContext ctx) {
    final colorScheme = Theme.of(ctx).colorScheme;
    return Consumer(
      builder: (ctx, ref, child) {
        final sentenceCount = ref.watch(playerProvider.select((st) => st?.sentenceCount ?? 0));
        if (sentenceCount == 0) return const SizedBox.shrink();
        final bool loop = ref.watch(
          playerProvider.select((st) => st?.videoState?.loop ?? false),
        );
        return IconButton(
          onPressed: () {
            if (loop) {
              _onLoop(ref);
            } else {
              _onUnloop(ref);
            }
          },
          icon: Icon(
            loop ? Icons.repeat_one_rounded : Icons.repeat_rounded,
            color: loop ? colorScheme.primary : colorScheme.outline,
          ),
          style: IconButton.styleFrom(tapTargetSize: .shrinkWrap),
          constraints: const BoxConstraints(minWidth: 30, minHeight: 30),
          padding: EdgeInsets.zero,
        );
      },
    );
  }

  Widget _speedDownButton(BuildContext ctx, WidgetRef ref) {
    return IconButton(
      onPressed: () => _onDecSpeed(ref),
      icon: const Icon(Icons.remove_circle_outline_rounded),
      color: Theme.of(ctx).colorScheme.outline,
      style: IconButton.styleFrom(tapTargetSize: .shrinkWrap),
      constraints: const BoxConstraints(minWidth: 30, minHeight: 30),
      padding: EdgeInsets.zero,
    );
  }

  Widget _speedUpButton(BuildContext ctx, WidgetRef ref) {
    return IconButton(
      onPressed: () => _onIncSpeed(ref),
      icon: const Icon(Icons.add_circle_outline_rounded),
      color: Theme.of(ctx).colorScheme.outline,
      style: IconButton.styleFrom(tapTargetSize: .shrinkWrap),
      constraints: const BoxConstraints(minWidth: 30, minHeight: 30),
      padding: EdgeInsets.zero,
    );
  }

  Widget _speedLabel(BuildContext ctx, WidgetRef ref) {
    final colorScheme = Theme.of(ctx).colorScheme;
    return GestureDetector(
      onTap: () => _onResetSpeed(ref),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: colorScheme.primaryContainer.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Consumer(
          builder: (ctx, ref, _) {
            final speed = ref.watch(playerProvider.select((st) => st?.videoState?.speed ?? 1));
            return Text(
              '${speed}x',
              style: TextStyle(
                color: colorScheme.primary,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            );
          },
        ),
      ),
    );
  }
}
