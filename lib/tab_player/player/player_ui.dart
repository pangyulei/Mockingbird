import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:marquee/marquee.dart';
import 'package:mockingbird/db/entities/en_media.dart';
import 'package:mockingbird/tab_player/player/player_provider.dart';
import 'package:mockingbird/tab_player/player/player_state.dart';
import 'package:mockingbird/tab_player/player/sentence_card/sentence_card_ui.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:video_player/video_player.dart';

import '../../app/app_route.dart';
import '../../tool/extensions.dart';

class PlayerUI extends ConsumerWidget {
  const PlayerUI({super.key});

  @override
  Widget build(BuildContext ctx, WidgetRef ref) {
    showLoading(ref.read(playerProvider.select((st) => st.isLoading)));
    ref.listen(
      playerProvider.select((st) => st.isLoading),
      (previous, next) => showLoading(next),
    );
    debugPrint('playerui build');
    final stateType = ref.watch(
      playerProvider.select((st) => st.value?.runtimeType),
    );
    switch (stateType) {
      case PlayerNull:
        return _empty(ctx);
      case PlayerData:
        return _page(ctx);
      default:
        debugPrint('playerui no such state $stateType');
        return Scaffold(appBar: _appBar());
    }
  }

  void _onAddSubtitle(WidgetRef ref) async {
    await ref.read(playerProvider.notifier).addSubtitle();
  }

  void _onToggleLoop(WidgetRef ref) {
    ref.read(playerProvider.notifier).toggleLoop();
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

  void _onVideoPositionChanged(
    WidgetRef ref,
    VideoPlayerController videoController,
  ) async {
    await ref
        .read(playerProvider.notifier)
        .videoPositionChanged(videoController);
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

  void _onScrollToPlayingSentence(WidgetRef ref) {
    ref.read(playerProvider.notifier).scrollToPlayingSentence();
  }

  void _onScrollToTop(WidgetRef ref) {
    ref.read(playerProvider.notifier).scrollToTop();
  }

  void _onScrollToBottom(WidgetRef ref) {
    ref.read(playerProvider.notifier).scrollToBottom();
  }

  void _onVolumeChanged(WidgetRef ref, double newVolume) async {
    await ref.read(playerProvider.notifier).updateVolume(newVolume);
  }

  void _onToggleVolume(WidgetRef ref) {
    ref.read(playerProvider.notifier).toggleVolume();
  }

  void _onGoToAlbums(BuildContext ctx) {
    ctx.go(AppRoute.albums);
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
    return Column(children: [_videoWidgets(), _sentenceList(ctx)]);
  }

  Widget _videoWidgets() {
    return Consumer(
      builder: (ctx, ref, child) {
        final videoController = ref.watch(
          playerProvider.select(
            (st) => (st.value as PlayerData).video.videoController,
          ),
        );
        videoController.addListener(
          () => _onVideoPositionChanged(ref, videoController),
        );
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

  Widget _displayer(
    BuildContext ctx,
    WidgetRef ref,
    VideoPlayerController videoController,
  ) {
    final String mediaPath = videoController.dataSource;
    final mediaType = MediaType.fromPath(mediaPath);
    if (mediaType == .video) {
      return _videoDisplayer(ctx, ref, videoController);
    } else {
      return _audioDisplayer(ctx, ref, videoController);
    }
  }

  Widget _videoDisplayer(
    BuildContext ctx,
    WidgetRef ref,
    VideoPlayerController videoController,
  ) {
    return AspectRatio(
      aspectRatio: 16 / 9.0,
      child: Stack(
        alignment: .center,
        children: [
          AspectRatio(
            aspectRatio: videoController.value.aspectRatio,
            child: VideoPlayer(videoController),
          ),
          _gradientDisplayerOverlay(),
          Row(
            mainAxisAlignment: .center,
            crossAxisAlignment: .end,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: .end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16, bottom: 8),
                      child: _progressSlider(ctx, videoController),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16, bottom: 8),
                child: _verticalVolumeWidgets(ref),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _audioDisplayer(
    BuildContext ctx,
    WidgetRef ref,
    VideoPlayerController videoController,
  ) {
    return SizedBox(
      height: 150,
      child: Stack(
        children: [
          VideoPlayer(videoController),
          _gradientDisplayerOverlay(),
          Column(
            mainAxisSize: .max,
            mainAxisAlignment: .start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                child: _horizontalVolumeWidgets(ref),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                child: _progressSlider(ctx, videoController),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _gradientDisplayerOverlay() {
    return Positioned.fill(
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
    );
  }

  Widget _sentenceList(BuildContext ctx) {
    return Expanded(
      child: ColoredBox(
        color: Theme.of(ctx).scaffoldBackgroundColor,
        child: Consumer(
          builder: (ctx, ref, child) {
            final (sentenceIdList, scrollController) = ref.watch(
              playerProvider
                  .select((st) => (st.value as PlayerData).video)
                  .select(
                    (videoData) =>
                        (videoData.sentenceIdList, videoData.scrollController),
                  ),
            );
            if (sentenceIdList.isEmpty) {
              return _noSubtitle(ctx, ref);
            }
            debugPrint('subtitle sentence list build');
            return ScrollablePositionedList.builder(
              itemCount: sentenceIdList.length,
              itemScrollController: scrollController,
              itemBuilder: (context, i) {
                return SentenceCardUI(sentenceIdList[i]);
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
        final sentenceCount = ref.watch(
          playerProvider.select(
            (st) => (st.value as PlayerData).video.sentenceIdList.length,
          ),
        );
        if (sentenceCount == 0) {
          return const SizedBox.shrink();
        } else {
          final colorScheme = Theme.of(context).colorScheme;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FloatingActionButton.small(
                heroTag: 'scroll_top',
                onPressed: () => _onScrollToTop(ref),
                backgroundColor: colorScheme.surfaceContainerHighest,
                foregroundColor: colorScheme.primary,
                child: const Icon(Icons.keyboard_arrow_up_rounded),
              ),
              const SizedBox(height: 8),
              FloatingActionButton.small(
                heroTag: 'scroll_focus',
                onPressed: () => _onScrollToPlayingSentence(ref),
                child: const Icon(Icons.center_focus_strong_rounded),
              ),
              const SizedBox(height: 8),
              FloatingActionButton.small(
                heroTag: 'scroll_bottom',
                onPressed: () => _onScrollToBottom(ref),
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

  Widget _verticalVolumeWidgets(WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Consumer(
          builder: (ctx, ref, child) {
            final showVolumeSlider = ref.watch(
              playerProvider.select(
                (st) => (st.value as PlayerData).video.showVolumeSlider,
              ),
            );
            if (showVolumeSlider) {
              return Expanded(child: _verticalVolumeSlider(ctx));
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
        _volumeButton(ref),
      ],
    );
  }

  Widget _horizontalVolumeWidgets(WidgetRef ref) {
    return Row(
      mainAxisAlignment: .start,
      children: [
        _volumeButton(ref),
        Consumer(
          builder: (ctx, ref, child) {
            final showVolumeSlider = ref.watch(
              playerProvider.select(
                (st) => (st.value as PlayerData).video.showVolumeSlider,
              ),
            );
            if (showVolumeSlider) {
              return Expanded(child: _horizontalVolumeSlider(ctx));
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ],
    );
  }

  Widget _volumeButton(WidgetRef ref) {
    return IconButton(
      onPressed: () => _onToggleVolume(ref),
      icon: Consumer(
        builder: (context, ref, child) {
          final volume = ref.watch(
            playerProvider.select(
              (st) => (st.value as PlayerData).video.volume,
            ),
          );
          final icon = volume == 0
              ? Icons.volume_off_rounded
              : Icons.volume_up_rounded;
          return Icon(icon);
        },
      ),
      color: Colors.white,
      iconSize: 32,
    );
  }

  Widget _verticalVolumeSlider(BuildContext ctx) {
    return RotatedBox(quarterTurns: 3, child: _horizontalVolumeSlider(ctx));
  }

  Widget _horizontalVolumeSlider(BuildContext ctx) {
    final colorScheme = Theme.of(ctx).colorScheme;
    return SliderTheme(
      data: SliderTheme.of(ctx).copyWith(
        trackHeight: 3.0,
        // thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 24.0),
        activeTrackColor: colorScheme.primary,
        inactiveTrackColor: Colors.white24,
        thumbColor: Colors.white,
        // padding: EdgeInsets.zero,
        thumbSize: WidgetStateProperty.all(const Size(20, 20)),
      ),
      child: Consumer(
        builder: (context, ref, child) {
          final volume = ref.watch(
            playerProvider.select(
              (st) => (st.value as PlayerData).video.volume,
            ),
          );
          return Slider(
            value: volume,
            onChanged: (newVolume) => _onVolumeChanged(ref, newVolume),
          );
        },
      ),
    );
  }

  Widget _progressSlider(
    BuildContext ctx,
    VideoPlayerController videoController,
  ) {
    final colorScheme = Theme.of(ctx).colorScheme;
    return SliderTheme(
      data: SliderTheme.of(ctx).copyWith(
        trackHeight: 3.0,
        // thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 24.0),
        activeTrackColor: colorScheme.primary,
        inactiveTrackColor: Colors.white24,
        thumbColor: Colors.white,
        // padding: EdgeInsets.zero,
        thumbSize: WidgetStateProperty.all(const Size(20, 20)),
      ),
      child: Consumer(
        builder: (context, ref, child) {
          final position = ref.watch(
            playerProvider.select(
              (st) => (st.value as PlayerData).video.positionMicro.toDouble(),
            ),
          );
          final duration = videoController.value.duration.inMicroseconds
              .toDouble();
          return Slider(
            value: position.clamp(0, duration),
            max: duration,
            onChangeStart: (val) => _onVideoSliderStartChanged(ref, val),
            onChanged: (val) => _onVideoSliderChanging(ref, val),
            onChangeEnd: (val) => _onVideoSliderEndChanged(ref, val),
          );
        },
      ),
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
                onPressed: () => _onGoToAlbums(ctx),
                icon: const Icon(Icons.library_music_rounded),
                label: const Text('Go to Albums'),
              ),
            ],
          ),
        ),
      ),
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
          final title = ref.watch(
            playerProvider.select((st) {
              final data = st.value;
              return data is PlayerData ? data.title : '';
            }),
          );
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

  Widget _controlBar(
    BuildContext ctx,
    WidgetRef ref,
    VideoPlayerController videoController,
  ) {
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
          playerProvider.select(
            (st) => (st.value as PlayerData).video.isPlaying,
          ),
        );
        return IconButton.filled(
          onPressed: () {
            if (isPlaying) {
              _onPause(ref);
            } else {
              _onPlay(ref);
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
      },
    );
  }

  Widget _loopButton(BuildContext ctx) {
    final colorScheme = Theme.of(ctx).colorScheme;
    return Consumer(
      builder: (ctx, ref, child) {
        debugPrint('playerui loopbutton build');
        final sentenceCount = ref.watch(
          playerProvider.select(
            (st) => (st.value as PlayerData).video.sentenceIdList.length,
          ),
        );
        if (sentenceCount == 0) return const SizedBox.shrink();
        final bool isLoop = ref.watch(
          playerProvider.select((st) => (st.value as PlayerData).video.isLoop),
        );
        return IconButton(
          onPressed: () => _onToggleLoop(ref),
          icon: Icon(
            isLoop ? Icons.repeat_one_rounded : Icons.repeat_rounded,
            color: isLoop ? colorScheme.primary : colorScheme.outline,
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
            final speed = ref.watch(
              playerProvider.select(
                (st) => (st.value as PlayerData).video.speed,
              ),
            );
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
