import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marquee/marquee.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:mockingbird/tab_player/player/player.dart';
import 'package:mockingbird/tab_player/player/player_bloc.dart';
import 'package:mockingbird/tab_player/player/player_event.dart';
import 'package:mockingbird/tab_player/player/player_state.dart';
import 'package:mockingbird/tool/extensions.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../sentence_card/sentence_card_ui.dart';

class PlayerUI extends StatefulWidget {
  final String? _mediaId;
  const PlayerUI({super.key, this._mediaId});

  @override
  State<StatefulWidget> createState() => _PlayerUIState();
}

class _PlayerUIState extends State<PlayerUI> {
  final _scrollController = ItemScrollController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          PlayerBloc(_scrollController, widget._mediaId)
            ..add(const PlayerInitEvent()),
      child: Builder(
        builder: (context) {
          final (stateType, loading) = context.select<PlayerBloc, (Type, bool)>(
            (bloc) => (bloc.state.runtimeType, bloc.state.loading),
          );
          showLoading(loading);
          switch (stateType) {
            case PlayerInitState:
              return _pageForInit();
            case PlayerEmptyState:
              return _pageForEmpty(context);
            case PlayerDataState:
              return _pageForData(context);
            default:
              assert(false, 'stateType $stateType missed');
              return const SizedBox.shrink();
          }
        },
      ),
    );
  }

  Widget _pageForInit() {
    return Scaffold(appBar: _appBar());
  }

  // void _onAddSubtitle(WidgetRef ref) async {
  //   // await ref.read(playerProvider(_scrollController).notifier).addSubtitle();
  // }

  // void _onScrollToPlayingSentence(WidgetRef ref) {
  //   ref
  //       .read(playerProvider(_scrollController).notifier)
  //       .scrollToPlayingSentence();
  // }

  // void _onScrollToTop(WidgetRef ref) {
  //   ref.read(playerProvider(_scrollController).notifier).scrollToTop();
  // }

  // void _onScrollToBottom(WidgetRef ref) {
  //   ref.read(playerProvider(_scrollController).notifier).scrollToBottom();
  // }

  // void _onVolumeChanged(WidgetRef ref, double newVolume) async {
  //   await ref.read(playerSettingProvider.notifier).updateVolume(newVolume);
  // }


  // void _onGoToAlbums(BuildContext context) {
  //   context.go(AppRoute.albumList);
  // }

  Widget _pageForData(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: _appBar(),
      body: Column(children: [_videoWidget(), _subtitleWidget()]),
      floatingActionButton: _floatingButtons(),
    );
  }

  Widget _videoWidget() {
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
      child: Column(children: [_displayer(), _controlBar()]),
    );
  }

  Widget _displayer() {
    return Builder(
      builder: (context) {
        final mediaType = context.select<PlayerBloc, AssetType>(
          (bloc) => bloc.state.as<PlayerDataState>()?.mediaType ?? .video,
        );
        if (mediaType == .video) {
          return _videoDisplayer();
        } else {
          return _audioDisplayer();
        }
      },
    );
  }

  Widget _videoDisplayer() {
    return AspectRatio(
      aspectRatio: 16 / 9.0,
      child: Stack(
        alignment: .center,
        children: [
          _player(),
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
                      child: _progressSlider(),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16, bottom: 8),
                child: _verticalVolumeWidgets(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _player() {
    return Video(
      controller: VideoController(SharedPlayer.player),
      pauseUponEnteringBackgroundMode: false,
      resumeUponEnteringForegroundMode: false,
    );
  }

  Widget _audioDisplayer() {
    return SizedBox(
      height: 150,
      child: Stack(
        children: [
          _player(),
          _gradientDisplayerOverlay(),
          Column(
            mainAxisSize: .max,
            mainAxisAlignment: .start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                child: _horizontalVolumeWidgets(),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                child: _progressSlider(),
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

  Widget _subtitleWidget() {
    return Expanded(
      child: ColoredBox(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Builder(
          builder: (context) {
            final subtitle = context.select<PlayerBloc, PlayerSubtitleState?>(
              (bloc) => bloc.state.as<PlayerDataState>()?.subtitle,
            );
            if (subtitle == null) {
              return const SizedBox.shrink();
            }
            switch (subtitle) {
              case PlayerSubtitleDataState subtitle:
                return ScrollablePositionedList.builder(
                  itemCount: subtitle.sentenceList.length,
                  itemScrollController: _scrollController,
                  itemBuilder: (context, i) {
                    return SentenceCardUI(subtitle.sentenceList[i], (
                      ref,
                      sentenceId,
                    ) {
                      // ref
                      //     .read(playerProvider(_scrollController).notifier)
                      //     .tapSentence(sentenceId);
                    });
                  },
                );
              case PlayerSubtitleEmptyState _:
                return _noSubtitle();
            }
          },
        ),
      ),
    );
  }

  Widget _noSubtitle() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return InkWell(
      onTap: () {
        // => _onAddSubtitle(ref)
      },
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
    return Builder(
      builder: (context) {
        final hasSubtitle = context.select<PlayerBloc, bool>(
          (bloc) =>
              bloc.state.as<PlayerDataState>()?.subtitle
                  is PlayerSubtitleDataState,
        );
        if (!hasSubtitle) return const SizedBox.shrink();
        final colorScheme = Theme.of(context).colorScheme;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FloatingActionButton.small(
              heroTag: 'scroll_top',
              onPressed: () {
                // _onScrollToTop(ref)
              },
              backgroundColor: colorScheme.surfaceContainerHighest,
              foregroundColor: colorScheme.primary,
              child: const Icon(Icons.keyboard_arrow_up_rounded),
            ),
            const SizedBox(height: 8),
            FloatingActionButton.small(
              heroTag: 'scroll_focus',
              onPressed: () {
                // _onScrollToPlayingSentence(ref)
              },
              child: const Icon(Icons.center_focus_strong_rounded),
            ),
            const SizedBox(height: 8),
            FloatingActionButton.small(
              heroTag: 'scroll_bottom',
              onPressed: () {
                // _onScrollToBottom(ref)
              },
              backgroundColor: colorScheme.surfaceContainerHighest,
              foregroundColor: colorScheme.primary,
              child: const Icon(Icons.keyboard_arrow_down_rounded),
            ),
          ],
        );
      },
    );
  }

  Widget _verticalVolumeWidgets() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Builder(
          builder: (context) {
            final bool showVolumeSlider = context.select<PlayerBloc, bool>(
              (bloc) =>
                  bloc.state.as<PlayerDataState>()?.showVolumeSlider ?? false,
            );
            if (showVolumeSlider) {
              return Expanded(child: _verticalVolumeSlider(context));
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
        _volumeButton(),
      ],
    );
  }

  Widget _horizontalVolumeWidgets() {
    return Row(
      mainAxisAlignment: .start,
      children: [
        _volumeButton(),
        Builder(
          builder: (context) {
            final bool showVolumeSlider = context.select<PlayerBloc, bool>(
              (bloc) =>
                  bloc.state.as<PlayerDataState>()?.showVolumeSlider ?? false,
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

  Widget _volumeButton() {
    return Builder(
      builder: (context) => IconButton(
        onPressed: () {
          context.read<PlayerBloc>().add(const PlayerToggleVolumeEvent());
        },
        icon: Builder(
          builder: (context) {
            final volume = context.select<PlayerBloc, double>(
              (bloc) => bloc.state.as<PlayerDataState>()?.volume ?? 1,
            );
            final icon = volume == 0
                ? Icons.volume_off_rounded
                : Icons.volume_up_rounded;
            return Icon(icon);
          },
        ),
        color: Colors.white,
        iconSize: 32,
      ),
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
      child: Builder(
        builder: (context) {
          final volume = context.select<PlayerBloc, double>(
            (bloc) => bloc.state.as<PlayerDataState>()?.volume ?? 1,
          );
          return Slider(
            value: volume,
            onChanged: (newVolume) {
              // => _onVolumeChanged(ref, newVolume)
            },
          );
        },
      ),
    );
  }

  Widget _progressSlider() {
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
      child: Builder(
        builder: (context) {
          final (position, duration) = context
              .select<PlayerBloc, (Duration, Duration)>(
                (bloc) => (
                  bloc.state.as<PlayerDataState>()?.position ??
                      const Duration(seconds: 0),
                  bloc.state.as<PlayerDataState>()?.duration ??
                      const Duration(seconds: 0),
                ),
              );
          final max = duration.inMilliseconds.toDouble();
          final val = position.inMilliseconds.clamp(0, max).toDouble();
          return Slider(
            value: val,
            max: max,
            onChangeStart: (val) {
              context.read<PlayerBloc>().add(
                PlayerVideoSliderStartChangeEvent(
                  Duration(milliseconds: val.toInt()),
                  duration,
                ),
              );
            },
            onChanged: (val) {
              context.read<PlayerBloc>().add(
                PlayerVideoSliderChangingEvent(
                  Duration(milliseconds: val.toInt()),
                  duration,
                ),
              );
            },
            onChangeEnd: (val) {
              context.read<PlayerBloc>().add(
                PlayerVideoSliderEndChangeEvent(
                  Duration(milliseconds: val.toInt()),
                  duration,
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _pageForEmpty(BuildContext context) {
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
                onPressed: () {
                  // _onGoToAlbums(context)
                },
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
      child: Builder(
        builder: (context) {
          final title = context.select<PlayerBloc, String>(
            (bloc) => bloc.state.as<PlayerDataState>()?.title ?? '',
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

  Widget _controlBar() {
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
          _playOrPauseButton(),
          const SizedBox(width: 16),
          _loopButton(),
          const Spacer(),
          _speedDownButton(),
          const SizedBox(width: 8),
          _speedLabel(),
          const SizedBox(width: 8),
          _speedUpButton(),
        ],
      ),
    );
  }

  Widget _playOrPauseButton() {
    final colorScheme = Theme.of(context).colorScheme;
    return Builder(
      builder: (context) {
        final playing = context.select<PlayerBloc, bool>(
          (bloc) => bloc.state.as<PlayerDataState>()?.playing ?? false,
        );
        return IconButton.filled(
          onPressed: () {
            if (playing) {
              context.read<PlayerBloc>().add(const PlayerPauseEvent());
            } else {
              context.read<PlayerBloc>().add(const PlayerPlayEvent());
            }
          },
          icon: Icon(
            playing ? Icons.pause_rounded : Icons.play_arrow_rounded,
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

  Widget _loopButton() {
    final colorScheme = Theme.of(context).colorScheme;
    return Builder(
      builder: (context) {
        final hasSubtitle = context.select<PlayerBloc, bool>(
          (bloc) =>
              bloc.state.as<PlayerDataState>()?.subtitle
                  is PlayerSubtitleDataState,
        );
        if (!hasSubtitle) return const SizedBox.shrink();
        final loop = context.select<PlayerBloc, bool>(
          (bloc) => bloc.state.as<PlayerDataState>()?.loopIndex != null,
        );
        return Builder(
          builder: (context) => IconButton(
            onPressed: () {
              context.read<PlayerBloc>().add(const PlayerToggleLoopEvent());
            },
            icon: Icon(
              loop ? Icons.repeat_one_rounded : Icons.repeat_rounded,
              color: loop ? colorScheme.primary : colorScheme.outline,
            ),
            style: IconButton.styleFrom(tapTargetSize: .shrinkWrap),
            constraints: const BoxConstraints(minWidth: 30, minHeight: 30),
            padding: EdgeInsets.zero,
          ),
        );
      },
    );
  }

  Widget _speedDownButton() {
    return Builder(
      builder: (context) => IconButton(
        onPressed: () {
          context.read<PlayerBloc>().add(const PlayerDecSpeedEvent());
        },
        icon: const Icon(Icons.remove_circle_outline_rounded),
        color: Theme.of(context).colorScheme.outline,
        style: IconButton.styleFrom(tapTargetSize: .shrinkWrap),
        constraints: const BoxConstraints(minWidth: 30, minHeight: 30),
        padding: EdgeInsets.zero,
      ),
    );
  }

  Widget _speedUpButton() {
    return Builder(
      builder: (context) => IconButton(
        onPressed: () {
          context.read<PlayerBloc>().add(const PlayerIncSpeedEvent());
        },
        icon: const Icon(Icons.add_circle_outline_rounded),
        color: Theme.of(context).colorScheme.outline,
        style: IconButton.styleFrom(tapTargetSize: .shrinkWrap),
        constraints: const BoxConstraints(minWidth: 30, minHeight: 30),
        padding: EdgeInsets.zero,
      ),
    );
  }

  Widget _speedLabel() {
    final colorScheme = Theme.of(context).colorScheme;
    return Builder(
      builder: (context) => GestureDetector(
        onTap: () =>
            context.read<PlayerBloc>().add(const PlayerResetSpeedEvent()),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Builder(
            builder: (context) {
              final speed = context.select<PlayerBloc, double>(
                (bloc) => bloc.state.as<PlayerDataState>()?.speed ?? 1,
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
      ),
    );
  }
}
