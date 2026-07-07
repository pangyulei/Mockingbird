import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:mockingbird/db/db_objectbox.dart';
import 'package:mockingbird/model/media.dart';
import 'package:mockingbird/model/sentence.dart';
import 'package:mockingbird/objectbox.g.dart';
import 'package:mockingbird/tab_player/player/player_ui.dart';
import 'package:mockingbird/tab_player/player/sentence_card/sentence_card_state.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:video_player/video_player.dart';
import 'player_state.dart';

const double _kMaxPlaySpeed = 3.0;
const double _kMinPlaySpeed = 0.25;
const double _kStepPlaySpeed = 0.25;

class PlayerScreen extends StatefulWidget {
  final int? _mediaId;
  const PlayerScreen(this._mediaId, {super.key});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen>
    implements PlayerUIOutputITF {
  var _state = const PlayerState.empty();
  final _subs = <StreamSubscription>[];
  Media? _media;
  VideoPlayerController? _videoController;
  final _scrollController = ItemScrollController();

  @override
  void initState() {
    super.initState();
    debugPrint('player initState mediaId: ${widget._mediaId}');
    _subs.add(_watchMedia(_reloadMedia));
    _reloadMedia();
  }

  void _reloadMedia() async {
    final mediaId = widget._mediaId;
    Future<void> setupNull() async {
      await _videoController?.dispose();
      _media = null;
      _videoController = null;
      setState(() {
        _state = const PlayerState.empty().copyWith(
          showLoading: false,
          showEmpty: true,
        );
      });
    }

    if (mediaId == null) {
      await setupNull();
      return;
    }
    setState(() {
      _state = _state.copyWith(showLoading: true, showEmpty: true);
    });
    final newMedia = await DBObjectBox().store.box<Media>().getAsync(mediaId);
    if (newMedia == null) {
      await setupNull();
      return;
    }
    final oldMedia = _media?.copyWith();
    _media = newMedia;
    if (oldMedia == newMedia) {
      debugPrint('same media notified');
      setState(() {
        _state = _state.copyWith(showLoading: false);
      });
      return;
    }
    final isVideoChanged = oldMedia?.path != newMedia.path;
    final subtitle = newMedia.subtitles.firstOrNull;
    // final isSubtitleChanged =
    //     oldMedia?.subtitles.firstOrNull != newMedia.subtitles.firstOrNull;
    final sentenceStates = subtitle?.sentences.map((s) => s.toCardState()).toList() ?? const [];

    if (isVideoChanged) {
      _state = const PlayerState.empty().copyWith(
        sentenceStates: sentenceStates,
        isPlaying: true,
      ).focus(sentenceStates.isEmpty ? null : 0);

      final newVideoController = VideoPlayerController.file(
        File(newMedia.path),
      );
      await newVideoController.initialize();
      newVideoController.addListener(
        () => _onPositionChanging(newVideoController),
      );
      await _videoController?.dispose();
      _videoController = newVideoController;

    } else {
      //subtitle changed/ or deleted
      final videoController = _videoController;
      if (videoController == null) {
        _state = const PlayerState.empty().copyWith(
          showLoading: false,
          showEmpty: true,
        );
      } else {
        final position = videoController.value.position;
        final playingIndex = _playingIndexByPosition(position);
        final repeat = playingIndex == null ? false : _state.repeat;
        _state = _state.copyWith(
            repeat: repeat,
            sentenceStates: sentenceStates).focus(playingIndex);
      }
    }
    //before video play need to setup state and refresh, otherwise position changing scroll to index will crash
    setState(() {
      _state = _state.copyWith(
        title: newMedia.name,
        showLoading: false,
        showEmpty: false,
      );
    });
    //Fix videoA scroll to very bottom, and play videoB, videoB doesnt immediately jumped to top
    if (_state.sentenceStates.isNotEmpty) {
      final focusedIndex = _state.focusedIndex;
      if (focusedIndex == null) {
        _scrollController._jumpTo(_state.sentenceStates.length - 1);
      } else {
        _scrollController._jumpTo(focusedIndex);
      }
    }
    if (isVideoChanged) {
      await _videoController?.play();
    }
  }

  StreamSubscription<void> _watchMedia(void Function() f) {
    final albumStream = DBObjectBox().store.watch<Media>();
    return albumStream.listen((event) => f());
  }

  @override
  void didUpdateWidget(covariant PlayerScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget._mediaId != oldWidget._mediaId) {
      debugPrint('player mediaId:${oldWidget._mediaId} => ${widget._mediaId}');
      _reloadMedia();
    }
  }

  @override
  void dispose() async {
    _cancelAllSubs();
    await _videoController?.dispose();
    super.dispose();
  }

  void _cancelAllSubs() {
    for (final sub in _subs) {
      sub.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PlayerUI(_state, this, _scrollController, _videoController);
  }

  void _onPositionChanging(VideoPlayerController videoController) async {
    final position = videoController.value.position;
    final mediaEnd = videoController.value.duration;
    if (position >= mediaEnd) {
      //if video end of duration, play/pause button should update
      setState(() {});
    }
    if (_state.sentenceStates.isEmpty) {
      //prevent videoController.play() but _state not setuped fully.
      debugPrint('no sentence on screen yet');
      return;
    }
    final media = _media;
    if (media == null) {
      debugPrint('media not found');
      return;
    }
    final subtitle = media.subtitles.firstOrNull;
    if (subtitle == null || subtitle.sentences.isEmpty) {
      debugPrint('no subtitle to spot');
      return;
    }
    final sentences = subtitle.sentences;
    if (_state.repeat) {
      //if repeat one is turn on, while sentence finished, seek to beginning
      final playingIndex = _state.focusedIndex;
      final isDraggingSlider = _state.videoSliderDraggingValue != null;
      debugPrint('repeat $playingIndex $isDraggingSlider');
      if (playingIndex != null && !isDraggingSlider) {
        final sentence = sentences[playingIndex];
        if (position > sentence.end) {
          debugPrint('positon changed, repeat index: $playingIndex');
          await videoController.seekTo(sentence.start);
        }
      }
    } else {
      //according to position, find current matched sentence index, marked as playingIndex
      final playingIndex = _playingIndexByPosition(position);
      final uiPlayingIndex = _state.focusedIndex;
      //scroll to playingIndex and focus it
      debugPrint(
        'playingindex $playingIndex uiPlayingIndex $uiPlayingIndex',
      );
      if (playingIndex != uiPlayingIndex) {
        //只有循環的時候，才需要持續自動滾動到當前句
        if (playingIndex == null) {
          _scrollController._scrollTo(_state.sentenceStates.length - 1);
        } else {
          _scrollController._scrollTo(playingIndex);
        }
        setState(() {
          _state = _state.focus(playingIndex);
        });
      }
    }
  }

  @override
  void player_onInOrder() {
    setState(() {
      _state = _state.copyWith(repeat: true);
    });
  }

  @override
  void player_onPause() async {
    setState(() {
      _state = _state.copyWith(isPlaying: false);
    });
    await _videoController?.pause();
  }

  @override
  void player_onPlay() async {
    setState(() {
      _state = _state.copyWith(isPlaying: true);
    });
    await _videoController?.play();
  }

  @override
  void player_onRepeatOne() {
    setState(() {
      _state = _state.copyWith(repeat: false);
    });
  }

  @override
  void player_onSpeedDown() async {
    final videoController = _videoController;
    if (videoController == null) return;
    final currentSpeed = videoController.value.playbackSpeed;
    var nextSpeed = max(_kMinPlaySpeed, currentSpeed - _kStepPlaySpeed);
    if (nextSpeed == currentSpeed) {
      return;
    }
    setState(() {
      _state = _state.copyWith(speed: nextSpeed);
    });
    await videoController.setPlaybackSpeed(nextSpeed);
  }

  @override
  void player_onSpeedUp() async {
    final videoController = _videoController;
    if (videoController == null) return;
    final currentSpeed = videoController.value.playbackSpeed;
    var nextSpeed = min(_kMaxPlaySpeed, currentSpeed + _kStepPlaySpeed);
    if (nextSpeed == currentSpeed) {
      return;
    }
    setState(() {
      _state = _state.copyWith(speed: nextSpeed);
    });
    await videoController.setPlaybackSpeed(nextSpeed);
  }

  @override
  void sentenceCard_onTap(int index) async {
    debugPrint('click sentence at $index ${_state.sentenceStates[index].text}');
    final videoController = _videoController;
    if (videoController == null) {
      debugPrint('videoController==null, nothing to control');
      return;
    }
    final sentence = _media?.subtitles.firstOrNull?.sentences.elementAtOrNull(
      index,
    );
    if (sentence == null) {
      debugPrint('sentence not found');
      return;
    }
    _scrollController._scrollTo(index);

    setState(() {
      _state = _state.focus(index).copyWith(isPlaying: true);
    });
    await videoController.seekTo(sentence.start);
    await videoController.play();
  }

  int? _playingIndexByPosition(Duration position) {
    final sentences = _media?.subtitles.firstOrNull?.sentences;
    if (sentences == null || sentences.isEmpty) return null;
    final mediaEnd = _videoController?.value.duration;
    if (mediaEnd == null) return null;

    final int? playingIndex;
    //从当前sentence开始判断这句是不是真的在播放中
    //从现在的 index，判断到最后，再从最前的index，判断到现在的index
    final allRange = List.generate(sentences.length, (index) => index);
    final focusedIndex = _state.focusedIndex;
    final List<int> searchRange;
    if (focusedIndex == null || focusedIndex >= sentences.length) {
      debugPrint('focus index not found or beyond range');
      searchRange = allRange;
    } else {
      final range1 = allRange.sublist(focusedIndex);
      final range2 = allRange.sublist(0, focusedIndex);
      searchRange = [...range1, ...range2];
    }
    playingIndex = searchRange.firstWhereOrNull(
      (idx) => _isSentencePlaying(idx, position),
    );
    return playingIndex;
  }

  bool _isSentencePlaying(int index, Duration position) {
    final sentences = _media?.subtitles.firstOrNull?.sentences;
    if (sentences == null || sentences.isEmpty) return false;

    final sentence = sentences[index];
    final nextSentence = sentences.elementAtOrNull(index + 1);
    final prevSentence = index == 0 ? null : sentences[index - 1];
    //刚开始的时候position=0,但是第一句话的start不一定是0
    //所以当position=0的时候，就不处于任何一句话的区间，这里直接做个判断就省了后面的几百句话的遍历
    final start = prevSentence == null
        ? const Duration(microseconds: 0)
        : sentence.start;
    if (nextSentence == null) {
      return start <= position && position <= sentence.end;
    } else {
      return start <= position && position < nextSentence.start;
    }
  }

  @override
  void player_onSpeedReset() async {
    final videoController = _videoController;
    if (videoController == null) return;
    final currentSpeed = videoController.value.playbackSpeed;
    const double nextSpeed = 1.0;
    if (nextSpeed == currentSpeed) {
      return;
    }
    setState(() {
      _state = _state.copyWith(speed: nextSpeed);
    });
    await videoController.setPlaybackSpeed(nextSpeed);
  }

  @override
  void player_onVideoSliderStartChanged(double microValue) async {
    setState(() {
      _state = _state.copyWith(
        videoSliderDraggingValue: () => microValue,
        isPlaying: false,
      );
    });
    await _videoController?.pause();
  }

  @override
  void player_onVideoSliderChanging(double microValue) async {
    final position = Duration(microseconds: microValue.toInt());
    final index = _playingIndexByPosition(position);
    if (index != null) {
      _scrollController._jumpTo(index);
    }
    setState(() {
      _state = _state.focus(index).copyWith(
        videoSliderDraggingValue: () => microValue,
      );
    });
    await _videoController?.seekTo(position);
  }

  @override
  void player_onVideoSliderEndChanged(double microValue) async {
    final position = Duration(microseconds: microValue.toInt());
    final sentences = _media?.subtitles.firstOrNull?.sentences;
    final index = _playingIndexByPosition(position);
    final sentence = index == null ? null : sentences?.elementAtOrNull(index);

    if (index != null && sentence != null) {
      await _videoController?.seekTo(sentence.start);
    }
    setState(() {
      _state = _state.copyWith(
        isPlaying: true,
        videoSliderDraggingValue: () => null,
      );
    });
    await _videoController?.play();
  }

  @override
  void player_onScrollToFocusedSentence() {
    final focusedIndex = _state.focusedIndex;
    if (focusedIndex != null &&
        focusedIndex >= 0 &&
        focusedIndex < _state.sentenceStates.length) {
      _scrollController._scrollTo(focusedIndex);
    }
  }

  @override
  void player_onScrollToTop() {
    if (_state.sentenceStates.isEmpty) {
      debugPrint('no sentence list to scroll');
      return;
    }
    _scrollController._scrollTo(0);
  }

  @override
  void player_onScrollToBottom() {
    if (_state.sentenceStates.isEmpty) {
      debugPrint('no sentence list to scroll');
      return;
    }
    _scrollController._scrollTo(_state.sentenceStates.length - 1);
  }

  @override
  void player_onVolumeChanging(double newVolume) async {
    setState(() {
      _state = _state.copyWith(volume: newVolume);
    });
    await _videoController?.setVolume(newVolume);
  }

  @override
  void player_onVolumeTap() {
    setState(() {
      _state = _state.copyWith(showVolumeSlider: !_state.showVolumeSlider);
    });
  }
}

extension on ItemScrollController {
  void _jumpTo(int index) {
    if (isAttached) {
      jumpTo(index: index, alignment: index == 0 ? 0 : 0.3);
    } else {
      debugPrint('${identityHashCode(this)} scroll is not attached');
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
      debugPrint('${identityHashCode(this)} scroll is not attached');
    }
  }
}

extension on Sentence {
  SentenceCardState toCardState() {
    String formatDuration(Duration d) {
      final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
      final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
      final milliseconds = (d.inMilliseconds.remainder(1000) ~/ 100).toString();
      return '$minutes:$seconds.$milliseconds';
    }
    return SentenceCardState(
      text: text,
      period: '${formatDuration(start)} - ${formatDuration(end)}',
      isFocused: false,
    );
  }
}

extension on PlayerState {
  PlayerState unfocus() {
    return copyWith(sentenceStates: sentenceStates.map((ss) => ss.copyWith(isFocused: false)).toList());
  }
  PlayerState focus(int? index) {
    if (index == null) {
      return unfocus();
    }
    return copyWith(
      sentenceStates: sentenceStates.asMap().entries.map((e) => e.value.copyWith(isFocused: index == e.key)).toList(),
    );
  }
  
  int? get focusedIndex {
    return sentenceStates.asMap().entries.firstWhereOrNull((e) => e.value.isFocused)?.key;
  }
}