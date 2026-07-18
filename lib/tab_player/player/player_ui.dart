import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marquee/marquee.dart';
import 'package:mockingbird/tab_player/player/sentence_card/sentence_card_provider.dart';
import 'package:mockingbird/tab_player/player/sentence_card/sentence_card_ui.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:video_player/video_player.dart';

import 'player_state.dart';

abstract interface class PlayerNotifierITF {
  int? sentenceIdAtIndex(int i);
  Future<void> play();
  Future<void> pause();
  Future<void> resetSpeed();
  Future<void> decSpeed();
  Future<void> incSpeed();
  Future<void> videoSliderStartChanged(double valMicro);
  Future<void> videoSliderChanging(double valMicro);
  Future<void> videoSliderEndChanged(double valMicro);
  void videoPositionChanged(VideoPlayerController videoController);
}

class PlayerUI extends ConsumerStatefulWidget {
  final ProviderListenable<PlayerState?> _provider;
  final PlayerNotifierITF _notifier;

  const PlayerUI(this._provider, this._notifier, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PlayerUIState();
}

class _PlayerUIState extends ConsumerState<PlayerUI> {
  final _scrollController = ItemScrollController();
  ProviderListenable<PlayerState?> get _provider => widget._provider;
  PlayerNotifierITF get _notifier => widget._notifier;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [_page(), _empty()]);
  }

  void _onVideoPositionChanged(VideoPlayerController videoController) {
    _notifier.videoPositionChanged(videoController);
  }

  void _onInOrder() {
    // setState(() {
    //   _state = _state.copyWith(repeat: true);
    // });
  }

  void _onPause() async {
    await _notifier.pause();
  }

  void _onPlay() async {
    await _notifier.play();
  }

  void _onRepeatOne() {
    // setState(() {
    //   _state = _state.copyWith(repeat: false);
    // });
  }

  void _onDecSpeed() async {
    await _notifier.decSpeed();
  }

  void _onIncSpeed() async {
    await _notifier.incSpeed();
  }

  void _onResetSpeed() async {
    await _notifier.resetSpeed();
  }

  @override
  void sentenceCard_onTap(int index) async {
    // debugPrint('click sentence at $index ${_state.sentenceStates[index].text}');
    // final videoController = _videoController;
    // if (videoController == null) {
    //   debugPrint('videoController==null, nothing to control');
    //   return;
    // }
    // final sentence = _media?.subtitles.firstOrNull?.sentences.elementAtOrNull(
    //   index,
    // );
    // if (sentence == null) {
    //   debugPrint('sentence not found');
    //   return;
    // }
    // _scrollController._scrollTo(index);

    // setState(() {
    //   _state = _state.focus(index).copyWith(isPlaying: true);
    // });
    // await videoController.seekTo(sentence.start);
    // await videoController.play();
  }

  int? _playingIndexByPosition(Duration position) {
    return null;

    // final sentences = _media?.subtitles.firstOrNull?.sentences;
    // if (sentences == null || sentences.isEmpty) return null;
    // final mediaEnd = _videoController?.value.duration;
    // if (mediaEnd == null) return null;

    // final int? playingIndex;
    // //从当前sentence开始判断这句是不是真的在播放中
    // //从现在的 index，判断到最后，再从最前的index，判断到现在的index
    // final allRange = List.generate(sentences.length, (index) => index);
    // final focusedIndex = _state.focusedIndex;
    // final List<int> searchRange;
    // if (focusedIndex == null || focusedIndex >= sentences.length) {
    //   debugPrint('focus index not found or beyond range');
    //   searchRange = allRange;
    // } else {
    //   final range1 = allRange.sublist(focusedIndex);
    //   final range2 = allRange.sublist(0, focusedIndex);
    //   searchRange = [...range1, ...range2];
    // }
    // playingIndex = searchRange.firstWhereOrNull(
    //   (idx) => _isSentencePlaying(idx, position),
    // );
    // return playingIndex;
  }

  bool _isSentencePlaying(int index, Duration position) {
    return false;
    // final sentences = _media?.subtitles.firstOrNull?.sentences;
    // if (sentences == null || sentences.isEmpty) {
    //   return false;
    // }

    // final sentence = sentences[index];
    // final nextSentence = sentences.elementAtOrNull(index + 1);
    // final prevSentence = index == 0 ? null : sentences[index - 1];
    // //刚开始的时候position=0,但是第一句话的start不一定是0
    // //所以当position=0的时候，就不处于任何一句话的区间，这里直接做个判断就省了后面的几百句话的遍历
    // final start = prevSentence == null
    //     ? const Duration(microseconds: 0)
    //     : sentence.start;
    // if (nextSentence == null) {
    //   return start <= position && position <= sentence.end;
    // } else {
    //   return start <= position && position < nextSentence.start;
    // }
  }

  void _onVideoSliderStartChanged(double valMicro) async {
    await _notifier.videoSliderStartChanged(valMicro);
  }

  void _onVideoSliderChanging(double valMicro) async {
    await _notifier.videoSliderChanging(valMicro);
  }

  void _onVideoSliderEndChanged(double valMicro) async {
    await _notifier.videoSliderEndChanged(valMicro);
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

  void _onVolumeChanged(double newVolume) async {
    // setState(() {
    //   _state = _state.copyWith(volume: newVolume);
    // });
    // await _videoController?.setVolume(newVolume);
  }

  void _onVolumeTap() {
    // setState(() {
    //   _state = _state.copyWith(showVolumeSlider: !_state.showVolumeSlider);
    // });
  }

  void _onGoToAlbums() {
    // context.go(AppRoute.albums);
  }

  Widget _page() {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: _appBar(),
      body: _body(),
      floatingActionButton: _floatingButtons(),
    );
  }

  Widget _body() {
    return Column(children: [_videoComponents(), _sentenceList()]);
  }

  Widget _videoComponents() {
    return Consumer(
      builder: (context, ref, child) {
        final videoController = ref.watch(
          _provider.select((st) => st?.videoState?.controller),
        );
        if (videoController == null) return const SizedBox.shrink();
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
              _displayer(videoController),
              _controlBar(videoController),
            ],
          ),
        );
      },
    );
  }

  Widget _displayer(VideoPlayerController videoController) {
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
            bottom: 0,
            child: Row(
              crossAxisAlignment: .end,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.5),
                    child: _videoSlider(videoController),
                  ),
                ),
                _volumeComponent(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sentenceList() {
    return Consumer(
      builder: (context, ref, child) {
        final theme = Theme.of(context);
        final sentenceCount = ref.watch(
          _provider.select((st) => st?.sentenceCount ?? 0),
        );
        if (sentenceCount == 0) {
          return const SizedBox.shrink();
        } else {
          return Expanded(
            child: ColoredBox(
              color: theme.scaffoldBackgroundColor,
              child: ScrollablePositionedList.builder(
                itemCount: sentenceCount,
                itemScrollController: _scrollController,
                itemBuilder: (context, i) {
                  final sentenceId = _notifier.sentenceIdAtIndex(i);
                  final provider = sentenceCardProvider(sentenceId);
                  final notifier = ref.read(provider.notifier);
                  return SentenceCardUI(provider, notifier);
                },
              ),
            ),
          );
        }
      },
    );
  }

  Widget? _floatingButtons() {
    return Consumer(
      builder: (context, ref, child) {
        final sentenceCount = ref.watch(
          _provider.select((st) => st?.sentenceCount ?? 0),
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

  Widget _volumeComponent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Consumer(
          builder: (ctx, ref, child) {
            final showVolumeSlider = ref.watch(
              _provider.select(
                (st) => st?.videoState?.showVolumeSlider ?? false,
              ),
            );
            if (showVolumeSlider) {
              return SizedBox(height: 100, child: _volumeSlider(ctx));
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
        IconButton(
          onPressed: _onVolumeTap,
          icon: Consumer(
            builder: (context, ref, child) {
              final volume = ref.watch(
                _provider.select((st) => st?.videoState?.volume ?? 1),
              );
              final icon = volume == 0
                  ? Icons.volume_off_rounded
                  : Icons.volume_up_rounded;
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
            final volume = ref.watch(
              _provider.select((st) => st?.videoState?.volume ?? 1),
            );
            return Slider(value: volume, onChanged: _onVolumeChanged);
          },
        ),
      ),
    );
  }

  Widget _videoSlider(VideoPlayerController videoController) {
    final colorScheme = Theme.of(context).colorScheme;
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        trackHeight: 4.0,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8.0),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 16.0),
        activeTrackColor: colorScheme.primary,
        inactiveTrackColor: Colors.white24,
        thumbColor: Colors.white,
      ),
      child: Consumer(
        builder: (context, ref, child) {
          final positionMicro = ref.watch(
            _provider.select((st) => st?.videoState?.positionMicro ?? 0),
          );
          return Slider(
            value: positionMicro.toDouble(),
            min: 0.0,
            max: videoController.value.duration.inMicroseconds.toDouble(),
            onChangeStart: _onVideoSliderStartChanged,
            onChangeEnd: _onVideoSliderEndChanged,
            onChanged: _onVideoSliderChanging,
          );
        },
      ),
    );
    // return ValueListenableBuilder(
    //   valueListenable: videoController,
    //   builder: (ctx, videoValue, child) {
    //     final int position = videoValue.position.inMicroseconds;
    //     final int duration = videoValue.duration.inMicroseconds;
    //     final draggingValue = _state.videoSliderDraggingValue;
    //     return SliderTheme(
    //       data: SliderTheme.of(ctx).copyWith(
    //         trackHeight: 4.0,
    //         thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8.0),
    //         overlayShape: const RoundSliderOverlayShape(overlayRadius: 16.0),
    //         activeTrackColor: colorScheme.primary,
    //         inactiveTrackColor: Colors.white24,
    //         thumbColor: Colors.white,
    //       ),
    //       child: Slider(
    //         value: draggingValue ?? position.clamp(0, duration).toDouble(),
    //         min: 0.0,
    //         max: duration.toDouble(),
    //         onChangeStart: _onVideoSliderStartChanged,
    //         onChangeEnd: _onVideoSliderEndChanged,
    //         onChanged: _onVideoSliderChanging,
    //       ),
    //     );
    //   },
    // );
  }

  Widget _empty() {
    return Consumer(
      builder: (context, ref, child) {
        final st = ref.watch(_provider);
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
                      color: colorScheme.primaryContainer.withValues(
                        alpha: 0.3,
                      ),
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
      // leading: IconButton(
      //   icon: const Icon(Icons.arrow_back_ios_new_rounded),
      //   onPressed: () => Navigator.of(ctx).pop(),
      // ),
      title: _title(),
    );
  }

  Widget _title() {
    return SizedBox(
      height: 24,
      child: Consumer(
        builder: (ctx, ref, _) {
          final title = ref.watch(_provider.select((st) => st?.title ?? ''));
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

  Widget _controlBar(VideoPlayerController videoController) {
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
          _repeatOneButton(),
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
    return Consumer(
      builder: (ctx, ref, child) {
        final isPlaying = ref.watch(
          _provider.select((st) => st?.videoState?.isPlaying ?? false),
        );
        return IconButton.filled(
          onPressed: () {
            if (isPlaying) {
              _onPause();
            } else {
              _onPlay();
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

  Widget _repeatOneButton() {
    final colorScheme = Theme.of(context).colorScheme;
    return Consumer(
      builder: (ctx, ref, _) {
        final sentenceCount = ref.watch(
          _provider.select((st) => st?.sentenceCount ?? 0),
        );
        if (sentenceCount == 0) return const SizedBox.shrink();
        final repeat = ref.watch(
          _provider.select((st) => st?.videoState?.repeat ?? false),
        );
        return IconButton(
          onPressed: () {
            if (repeat) {
              _onRepeatOne();
            } else {
              _onInOrder();
            }
          },
          icon: Icon(
            repeat ? Icons.repeat_one_rounded : Icons.repeat_rounded,
            color: repeat ? colorScheme.primary : colorScheme.outline,
          ),
          style: IconButton.styleFrom(tapTargetSize: .shrinkWrap),
          constraints: const BoxConstraints(minWidth: 30, minHeight: 30),
          padding: EdgeInsets.zero,
        );
      },
    );
  }

  Widget _speedDownButton() {
    return IconButton(
      onPressed: _onDecSpeed,
      icon: const Icon(Icons.remove_circle_outline_rounded),
      color: Theme.of(context).colorScheme.outline,
      style: IconButton.styleFrom(tapTargetSize: .shrinkWrap),
      constraints: const BoxConstraints(minWidth: 30, minHeight: 30),
      padding: EdgeInsets.zero,
    );
  }

  Widget _speedUpButton() {
    return IconButton(
      onPressed: _onIncSpeed,
      icon: const Icon(Icons.add_circle_outline_rounded),
      color: Theme.of(context).colorScheme.outline,
      style: IconButton.styleFrom(tapTargetSize: .shrinkWrap),
      constraints: const BoxConstraints(minWidth: 30, minHeight: 30),
      padding: EdgeInsets.zero,
    );
  }

  Widget _speedLabel() {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: _onResetSpeed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: colorScheme.primaryContainer.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Consumer(
          builder: (ctx, ref, _) {
            final speed = ref.watch(
              _provider.select((st) => st?.videoState?.speed ?? 1),
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

extension on ItemScrollController {
  void _jumpTo(int index) {
    if (isAttached) {
      jumpTo(index: index, alignment: index == 0 ? 0 : 0.3);
    } else {
      debugPrint('${identityHashCode(this)} jump fail, scroll is not attached');
    }
  }

  void _scrollTo(int index) {
    if (isAttached) {
      scrollTo(
        index: index,
        duration: const Duration(milliseconds: 250),
        alignment: index == 0 ? 0 : 0.3,
      );
    } else {
      debugPrint(
        '${identityHashCode(this)} scroll fail, scroll is not attached',
      );
    }
  }
}

// extension on PlayerState {
//   PlayerState unfocus() {
//     return copyWith(
//       sentenceStates: sentenceStates
//           .map((ss) => ss.copyWith(isFocused: false))
//           .toList(),
//     );
//   }

//   PlayerState focus(int? index) {
//     if (index == null) {
//       return unfocus();
//     }
//     return copyWith(
//       sentenceStates: sentenceStates
//           .asMap()
//           .entries
//           .map((e) => e.value.copyWith(isFocused: index == e.key))
//           .toList(),
//     );
//   }

//   int? get focusedIndex {
//     int i = sentenceStates.indexWhere((s) => s.isFocused);
//     return i == -1 ? null : i;
//     // return sentenceStates
//     //     .asMap()
//     //     .entries
//     //     .firstWhereOrNull((e) => e.value.isFocused)
//     //     ?.key;
//   }
// }

// void _reloadMedia() async {
//   final mediaId = widget._mediaId;
//   Future<void> setupNull() async {
//     await _videoController?.dispose();
//     _media = null;
//     _videoController = null;
//     setState(() {
//       _state = const PlayerState.empty().copyWith(
//         showLoading: false,
//         showEmpty: true,
//       );
//     });
//   }

//   if (mediaId == null) {
//     await setupNull();
//     return;
//   }
//   setState(() {
//     _state = _state.copyWith(
//       showLoading: true,
//       showEmpty: _videoController == null,
//     );
//   });
//   final newMedia = await DBObjectBox().store.box<EnMedia>().getAsync(mediaId);
//   if (newMedia == null) {
//     await setupNull();
//     return;
//   }
//   final oldMedia = _media?.copyWith();
//   _media = newMedia;
//   if (oldMedia == newMedia) {
//     debugPrint('same media notified');
//     setState(() {
//       _state = _state.copyWith(showLoading: false);
//     });
//     return;
//   }
//   final isVideoChanged = oldMedia?.path != newMedia.path;
//   final subtitle = newMedia.subtitles.firstOrNull;
//   // final isSubtitleChanged =
//   //     oldMedia?.subtitles.firstOrNull != newMedia.subtitles.firstOrNull;
//   final sentenceStates =
//       subtitle?.sentences.map((s) => s.toCardState()).toList() ?? const [];

//   if (isVideoChanged) {
//     _state = const PlayerState.empty()
//         .copyWith(sentenceStates: sentenceStates, isPlaying: true)
//         .focus(sentenceStates.isEmpty ? null : 0);

//   } else {
//     //subtitle changed/ or deleted
//     final videoController = _videoController;
//     if (videoController == null) {
//       _state = const PlayerState.empty().copyWith(
//         showLoading: false,
//         showEmpty: true,
//       );
//     } else {
//       final position = videoController.value.position;
//       final playingIndex = _playingIndexByPosition(position);
//       final repeat = playingIndex == null ? false : _state.repeat;
//       _state = _state
//           .copyWith(repeat: repeat, sentenceStates: sentenceStates)
//           .focus(playingIndex);
//     }
//   }
//   //before video play need to setup state and refresh, otherwise position changing scroll to index will crash
//   setState(() {
//     _state = _state.copyWith(
//       title: newMedia.name,
//       showLoading: false,
//       showEmpty: false,
//     );
//   });
//   //Fix videoA scroll to very bottom, and play videoB, videoB doesnt immediately jumped to top
//   if (_state.sentenceStates.isNotEmpty) {
//     final focusedIndex = _state.focusedIndex;
//     if (focusedIndex == null) {
//       _scrollController._jumpTo(_state.sentenceStates.length - 1);
//     } else {
//       _scrollController._jumpTo(focusedIndex);
//     }
//   }
//   if (isVideoChanged) {
//     await _videoController?.play();
//   }
// }
