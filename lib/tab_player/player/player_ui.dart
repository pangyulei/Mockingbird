import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:marquee/marquee.dart';
import 'package:mockingbird/tab_player/player/player_media_controller.dart';
import 'package:mockingbird/tab_player/player/providers/player_loop_provider.dart';
import 'package:mockingbird/tab_player/player/providers/player_media_provider.dart';
import 'package:mockingbird/tab_player/player/providers/player_provider.dart';
import 'package:mockingbird/tab_player/player/providers/player_setting_provider.dart';
import 'package:mockingbird/tab_player/player/providers/player_subtitle_provider.dart';
import 'package:mockingbird/tab_player/player/providers/player_title_provider.dart';
import 'package:mockingbird/tab_player/player/states/player_media_state.dart';
import 'package:mockingbird/tab_player/player/states/player_subtitle_state.dart';
import 'package:mockingbird/tool/extensions.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../app/app_route.dart';
import '../sentence_card/sentence_card_ui.dart';

class PlayerUI extends ConsumerStatefulWidget {
  const PlayerUI({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => PlayerUIState();
}

class PlayerUIState extends ConsumerState<PlayerUI> {
  final _scrollController = ItemScrollController();

  @override
  Widget build(BuildContext context) {
    //keep playerProvider alive while page exist
    ref.listen(playerProvider(_scrollController), (previous, next) {});
    ref.listen(playerLoopProvider, (previous, next) {});
    final stateType = ref.watch(
      playerMediaProvider.select((st) => st.value?.runtimeType),
    );
    debugPrint('player state type $stateType');
    switch (stateType) {
      case PlayerMediaNull:
        return _empty(context);
      case PlayerMediaData:
        return _page(context);
      default:
        return Scaffold(appBar: _appBar());
    }
  }

  void _onAddSubtitle(WidgetRef ref) async {
    // await ref.read(playerProvider(_scrollController).notifier).addSubtitle();
  }

  void _onToggleLoop(WidgetRef ref) {
    ref.read(playerLoopProvider.notifier).toggleLoop();
  }

  void _onPause(WidgetRef ref) async {
    await ref.read(playerMediaProvider.notifier).pause();
  }

  void _onPlay(WidgetRef ref) async {
    await ref.read(playerMediaProvider.notifier).play();
  }

  void _onDecSpeed(WidgetRef ref) async {
    await ref.read(playerSettingProvider.notifier).decSpeed();
  }

  void _onIncSpeed(WidgetRef ref) async {
    await ref.read(playerSettingProvider.notifier).incSpeed();
  }

  void _onResetSpeed(WidgetRef ref) async {
    await ref.read(playerSettingProvider.notifier).resetSpeed();
  }

  void _onVideoSliderStartChanged(
    WidgetRef ref,
    Duration position,
    Duration duration,
  ) async {
    await ref
        .read(playerProvider(_scrollController).notifier)
        .videoSliderStartChanged(position, duration);
  }

  void _onVideoSliderChanging(
    WidgetRef ref,
    Duration position,
    Duration duration,
  ) async {
    await ref
        .read(playerProvider(_scrollController).notifier)
        .videoSliderChanging(position, duration);
  }

  void _onVideoSliderEndChanged(
    WidgetRef ref,
    Duration position,
    Duration duration,
  ) async {
    await ref
        .read(playerProvider(_scrollController).notifier)
        .videoSliderEndChanged(position, duration);
  }

  void _onScrollToPlayingSentence(WidgetRef ref) {
    ref
        .read(playerProvider(_scrollController).notifier)
        .scrollToPlayingSentence();
  }

  void _onScrollToTop(WidgetRef ref) {
    ref.read(playerProvider(_scrollController).notifier).scrollToTop();
  }

  void _onScrollToBottom(WidgetRef ref) {
    ref.read(playerProvider(_scrollController).notifier).scrollToBottom();
  }

  void _onVolumeChanged(WidgetRef ref, double newVolume) async {
    await ref.read(playerSettingProvider.notifier).updateVolume(newVolume);
  }

  void _onToggleVolume(WidgetRef ref) {
    ref.read(playerSettingProvider.notifier).toggleVolume();
  }

  void _onGoToAlbums(BuildContext context) {
    context.go(AppRoute.albumList);
  }

  Widget _page(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: _appBar(),
      body: _body(context),
      floatingActionButton: _floatingButtons(),
    );
  }

  Widget _body(BuildContext context) {
    return Column(children: [_videoWidgets(context), _sentenceList(context)]);
  }

  Widget _videoWidgets(BuildContext context) {
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
      child: Consumer(
        builder: (context, ref, child) {
          final videoController = ref.watch(
            playerMediaProvider.select(
              (st) => (st.value as PlayerMediaData).mediaController,
            ),
          );
          return Column(
            children: [
              _displayer(context, ref, videoController),
              _controlBar(context, ref),
            ],
          );
        },
      ),
    );
  }

  Widget _displayer(
    BuildContext context,
    WidgetRef ref,
    PlayerMediaControllerITF mediaController,
  ) {
    if (mediaController.type == .video) {
      return _videoDisplayer(context, ref, mediaController);
    } else {
      return _audioDisplayer(context, ref, mediaController);
    }
  }

  Widget _videoDisplayer(
    BuildContext context,
    WidgetRef ref,
    PlayerMediaControllerITF mediaController,
  ) {
    debugPrint('ui media ratio ${mediaController.ratio}');
    const ratio = 16 / 9.0;
    return AspectRatio(
      aspectRatio: ratio,
      child: Stack(
        alignment: .center,
        children: [
          mediaController.video,
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
                      child: _progressSlider(context, mediaController),
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
    BuildContext context,
    WidgetRef ref,
    PlayerMediaControllerITF mediaController,
  ) {
    return SizedBox(
      height: 150,
      child: Stack(
        children: [
          mediaController.video,
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
                child: _progressSlider(context, mediaController),
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

  Widget _sentenceList(BuildContext context) {
    return Expanded(
      child: ColoredBox(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Consumer(
          builder: (context, ref, child) {
            final data = ref.watch(playerSubtitleProvider).value;
            if (data is PlayerSubtitleData) {
              return ScrollablePositionedList.builder(
                itemCount: data.sentenceIdList.length,
                itemScrollController: _scrollController,
                itemBuilder: (context, i) {
                  return SentenceCardUI(data.sentenceIdList[i], (
                    ref,
                    sentenceId,
                  ) {
                    ref
                        .read(playerProvider(_scrollController).notifier)
                        .tapSentence(sentenceId);
                  });
                },
              );
            } else if (data is PlayerSubtitleEmpty) {
              return _noSubtitle(context, ref);
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }

  Widget _noSubtitle(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
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
        final show = ref.watch(
          playerSubtitleProvider.select((st) => st.value is PlayerSubtitleData),
        );
        if (!show) return const SizedBox.shrink();
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
      },
    );
  }

  Widget _verticalVolumeWidgets(WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Consumer(
          builder: (context, ref, child) {
            final bool showVolumeSlider = ref.watch(
              playerSettingProvider.select((st) => st.showVolumeSlider),
            );
            if (showVolumeSlider) {
              return Expanded(child: _verticalVolumeSlider(context));
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
          builder: (context, ref, child) {
            final showVolumeSlider = ref.watch(
              playerSettingProvider.select((st) => st.showVolumeSlider),
            );
            if (showVolumeSlider) {
              return Expanded(child: _horizontalVolumeSlider(context));
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
            playerSettingProvider.select((st) => st.volume),
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

  Widget _verticalVolumeSlider(BuildContext context) {
    return RotatedBox(quarterTurns: 3, child: _horizontalVolumeSlider(context));
  }

  Widget _horizontalVolumeSlider(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
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
            playerSettingProvider.select((st) => st.volume),
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
    BuildContext context,
    PlayerMediaControllerITF mediaController,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
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
          final (position, duration) = ref.watch(
            playerMediaProvider
                .select((st) => st.value?.as<PlayerMediaData>())
                .select(
                  (st) => (
                    st?.position ?? const Duration(seconds: 0),
                    st?.duration ?? const Duration(seconds: 0),
                  ),
                ),
          );
          final max = duration.inMilliseconds.toDouble();
          final val = position.inMilliseconds.clamp(0, max).toDouble();
          return Slider(
            value: val,
            max: max,
            onChangeStart: (val) => _onVideoSliderStartChanged(
              ref,
              Duration(milliseconds: val.toInt()),
              duration,
            ),
            onChanged: (val) => _onVideoSliderChanging(
              ref,
              Duration(milliseconds: val.toInt()),
              duration,
            ),
            onChangeEnd: (val) => _onVideoSliderEndChanged(
              ref,
              Duration(milliseconds: val.toInt()),
              duration,
            ),
          );
        },
      ),
    );
  }

  Widget _empty(BuildContext context) {
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
                onPressed: () => _onGoToAlbums(context),
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
        builder: (context, ref, _) {
          final title = ref.watch(
            playerTitleProvider.select((st) => st.value ?? ''),
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

  Widget _controlBar(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
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
          _playOrPauseButton(context),
          const SizedBox(width: 16),
          _loopButton(context),
          const Spacer(),
          _speedDownButton(context, ref),
          const SizedBox(width: 8),
          _speedLabel(context, ref),
          const SizedBox(width: 8),
          _speedUpButton(context, ref),
        ],
      ),
    );
  }

  Widget _playOrPauseButton(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Consumer(
      builder: (context, ref, child) {
        final isPlaying = ref.watch(
          playerMediaProvider.select(
            (st) => (st.value as PlayerMediaData).playing,
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

  Widget _loopButton(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Consumer(
      builder: (context, ref, child) {
        final hasSubtitle = ref.watch(
          playerSubtitleProvider.select((st) => st.value is PlayerSubtitleData),
        );
        if (!hasSubtitle) return const SizedBox.shrink();
        final loop = ref.watch(
          playerLoopProvider.select((st) => st.value?.loop),
        );
        if (loop == null) return const SizedBox.shrink();
        return IconButton(
          onPressed: () => _onToggleLoop(ref),
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

  Widget _speedDownButton(BuildContext context, WidgetRef ref) {
    return IconButton(
      onPressed: () => _onDecSpeed(ref),
      icon: const Icon(Icons.remove_circle_outline_rounded),
      color: Theme.of(context).colorScheme.outline,
      style: IconButton.styleFrom(tapTargetSize: .shrinkWrap),
      constraints: const BoxConstraints(minWidth: 30, minHeight: 30),
      padding: EdgeInsets.zero,
    );
  }

  Widget _speedUpButton(BuildContext context, WidgetRef ref) {
    return IconButton(
      onPressed: () => _onIncSpeed(ref),
      icon: const Icon(Icons.add_circle_outline_rounded),
      color: Theme.of(context).colorScheme.outline,
      style: IconButton.styleFrom(tapTargetSize: .shrinkWrap),
      constraints: const BoxConstraints(minWidth: 30, minHeight: 30),
      padding: EdgeInsets.zero,
    );
  }

  Widget _speedLabel(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () => _onResetSpeed(ref),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: colorScheme.primaryContainer.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Consumer(
          builder: (context, ref, _) {
            final speed = ref.watch(
              playerSettingProvider.select((st) => st.speed),
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
