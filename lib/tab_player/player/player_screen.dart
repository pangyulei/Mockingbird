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
    final mediaId = widget._mediaId;
    debugPrint('player initState mediaId: $mediaId');
    if (mediaId == null) {
      _state = _state.copyWith(showLoading: false, showEmpty: true);
    } else {
      _state = _state.copyWith(showLoading: true, showEmpty: true);
      _subscribeMedia(mediaId);
    }
  }

  void _subscribeMedia(int mediaId) async {
    final mediaBox = DBObjectBox().store.box<Media>();
    final mediaStream = mediaBox
        .query(Media_.id.equals(mediaId))
        .watch(triggerImmediately: true)
        .map((q) async => await q.findAsync());
    final sub = mediaStream.listen((event) async {
      final newMedia = (await event).firstOrNull;
      _receiveMedia(newMedia);
    });
    _subs.add(sub);
  }

  void _receiveMedia(Media? newMedia) async {
    final oldMedia = _media?.copyWith();
    _media = newMedia;
    if (newMedia != null) {
      await _videoController?.pause();
      final isVideoChanged = oldMedia?.path != newMedia.path;
      final int? focusIndex;
      final int? repeatIndex;
      final subtitle = newMedia.subtitles.firstOrNull;
      final hasSubtitle = subtitle != null && subtitle.sentences.isNotEmpty;
      if (isVideoChanged) {
        focusIndex = hasSubtitle ? 0 : null;
        repeatIndex = null;
      } else {
        final videoController = _videoController;
        if (videoController == null || !hasSubtitle) {
          focusIndex = null;
          repeatIndex = null;
        } else {
          final position = videoController.value.position;
          focusIndex = _sentenceIndexByPosition(position);
          repeatIndex = _state.repeatIndex == null ? null : focusIndex;
        }
      }
      //before video play need to setup state and refresh, otherwise position changing scroll to index will crash
      setState(() {
        _state = _state.copyWith(
          sentenceStates: _sentenceStates(newMedia),
          focusedIndex: () => focusIndex,
          repeatIndex: () => repeatIndex,
          title: newMedia.name,
        );
      });

      if (isVideoChanged) {
        final newVideoController = VideoPlayerController.file(
          File(newMedia.path),
        );
        await newVideoController.initialize();
        newVideoController.addListener(
          () => _onPositionChanging(newVideoController),
        );
        await _videoController?.dispose();
        _videoController = newVideoController;
        _state = _state.copyWith(videoController: () => newVideoController);
      }
      // //Fix videoA scroll to very bottom, and play videoB, videoB doesnt immediately jumped to top
      WidgetsBinding.instance.addPostFrameCallback((_){
        if (focusIndex != null) {
          _scrollController._jumpTo(focusIndex);
        }
      });
    }
    setState(() {
      _state = _state.copyWith(showLoading: false, showEmpty: newMedia == null);
    });
    await _videoController?.play();
  }

  @override
  void didUpdateWidget(covariant PlayerScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget._mediaId != oldWidget._mediaId) {
      debugPrint('player mediaId:${oldWidget._mediaId} => ${widget._mediaId}');
      final mediaId = widget._mediaId;
      _cancelAllSubs();
      if (mediaId == null) {
        _media = null;
        setState(() {
          _state = _state.copyWith(showLoading: false, showEmpty: true);
        });
      } else {
        setState(() {
          _state = _state.copyWith(showLoading: true, showEmpty: false);
        });
        _subscribeMedia(mediaId);
      }
    }
  }

  List<SentenceCardState> _sentenceStates(Media? media) {
    if (media == null) {
      return const [];
    }
    final sentences = media.subtitles.firstOrNull?.sentences;
    final sentenceStates =
        sentences?.asMap().entries.map((e) {
          int i = e.key;
          Sentence s = e.value;
          return SentenceCardState(
            isFocused: i == 0,
            text: s.text,
            period: '${_formatDuration(s.start)} - ${_formatDuration(s.end)}',
            index: i,
          );
        }).toList() ??
        const [];
    return sentenceStates;
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    final milliseconds = (d.inMilliseconds.remainder(1000) ~/ 100).toString();
    return '$minutes:$seconds.$milliseconds';
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
    return PlayerUI(_state, this, _scrollController);
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
    final repeatIndex = _state.repeatIndex;
    if (repeatIndex == null) {
      //according to position, find current matched sentence index, marked as playingIndex
      final playingIndex = _sentenceIndexByPosition(position);
      if (playingIndex == null) {
        debugPrint('playing index not found');
        return;
      }
      //scroll to playingIndex and focus it
      if (playingIndex != _state.focusedIndex) {
        //只有循環的時候，才需要持續自動滾動到當前句
        _scrollController._scrollTo(playingIndex);
        setState(() {
          _state = _state.copyWith(focusedIndex: () => playingIndex);
        });
      }
    } else {
      //if repeat one is turn on, while sentence finished, seek to beginning
      final isDraggingSlider = _state.videoSliderDraggingValue != null;
      if (!isDraggingSlider) {
        final sentence = sentences[repeatIndex];
        if (position > sentence.end) {
          debugPrint('positon changed, repeat index: $repeatIndex');
          await videoController.seekTo(sentence.start);
        }
      }
    }
  }

  @override
  void player_onInOrder() {
    setState(() {
      _state = _state.copyWith(repeatIndex: () => _state.focusedIndex);
    });
  }

  @override
  void player_onPause() async {
    await _videoController?.pause();
    setState(() {});
  }

  @override
  void player_onPlay() async {
    await _videoController?.play();
    setState(() {});
  }

  @override
  void player_onRepeatOne() {
    setState(() {
      _state = _state.copyWith(repeatIndex: () => null);
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
    await videoController.setPlaybackSpeed(nextSpeed);
    setState(() {});
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
    await videoController.setPlaybackSpeed(nextSpeed);
    setState(() {});
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
    final repeatIndex = _state.repeatIndex == null ? null : index;
    _state = _state.copyWith(
      focusedIndex: () => index,
      repeatIndex: () => repeatIndex,
    );
    await videoController.seekTo(sentence.start);
    await videoController.play();
    setState(() {});
  }

  int? _sentenceIndexByPosition(Duration position) {
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
    if (focusedIndex == null) {
      debugPrint('focus index not found');
      searchRange = allRange;
    } else {
      final range1 = allRange.sublist(focusedIndex);
      final range2 = allRange.sublist(0, focusedIndex);
      searchRange = [...range1, ...range2];
    }
    playingIndex = searchRange.firstWhereOrNull(
      (idx) => _isSentencePlaying(idx, position, mediaEnd),
    );
    return playingIndex;
  }

  bool _isSentencePlaying(int index, Duration position, Duration mediaEnd) {
    final sentences = _media?.subtitles.firstOrNull?.sentences;
    if (sentences == null || sentences.isEmpty) return false;
    if (sentences.length == 1) return true;

    final sentence = sentences[index];
    final nextSentence = sentences.elementAtOrNull(index + 1);
    final prevSentence = index == 0 ? null : sentences[index - 1];
    //刚开始的时候position=0,但是第一句话的start不一定是0
    //所以当position=0的时候，就不处于任何一句话的区间，这里直接做个判断就省了后面的几百句话的遍历
    final start = prevSentence == null
        ? const Duration(microseconds: 0)
        : sentence.start;
    if (nextSentence == null) {
      return start <= position && position <= mediaEnd;
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
    await videoController.setPlaybackSpeed(nextSpeed);
    setState(() {});
  }

  @override
  void player_onVideoSliderStartChanged(double microValue) async {
    _state = _state.copyWith(videoSliderDraggingValue: () => microValue);
    await _videoController?.pause();
    setState(() {});
  }

  @override
  void player_onVideoSliderChanging(double microValue) async {
    final position = Duration(microseconds: microValue.toInt());
    final index = _sentenceIndexByPosition(position);
    _state = _state.copyWith(
      videoSliderDraggingValue: () => microValue,
      focusedIndex: () => index,
    );
    if (index != null) {
      _scrollController._jumpTo(index);
    }
    await _videoController?.seekTo(position);
    setState(() {});
  }

  @override
  void player_onVideoSliderEndChanged(double microValue) async {
    final position = Duration(microseconds: microValue.toInt());
    final sentences = _media?.subtitles.firstOrNull?.sentences;
    final index = _sentenceIndexByPosition(position);
    final sentence = index == null ? null : sentences?.elementAtOrNull(index);

    if (index != null && sentence != null) {
      final repeatIndex = _state.repeatIndex == null ? null : index;
      _state = _state.copyWith(repeatIndex: () => repeatIndex);
      await _videoController?.seekTo(sentence.start);
    }
    _state = _state.copyWith(videoSliderDraggingValue: () => null);
    await _videoController?.play();
    setState(() {});
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
    await _videoController?.setVolume(newVolume);
    setState(() {});
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
