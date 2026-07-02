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
  //if no mediaId passed, means empty
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
    _observeMedia();
  }

  void _observeMedia() {
    final mediaId = widget._mediaId;
    if (mediaId == null) {
      debugPrint('no mediaId');
      return;
    }
    _state = _state.copyWith(showLoading: true, showEmpty: true);
    final mediaBox = DBObjectBox().store.box<Media>();
    final mediaStream = mediaBox
        .query(Media_.id.equals(mediaId))
        .watch(triggerImmediately: true)
        .map((q) async => await q.findFirstAsync());
    final sub = mediaStream.listen((event) async {
      final prevMedia = _media?.copyWith();
      _media = await event;
      final media = _media;
      if (media == null) {
        debugPrint('no media found');
        return;
      }

      if (media.path != prevMedia?.path) {
        final newVideoController = VideoPlayerController.file(File(media.path));
        await newVideoController.initialize();
        await _videoController?.dispose();
        _videoController = newVideoController;
        _videoController?.addListener(
          () => _onPositionChanged(newVideoController),
        );
        _state = _state.copyWith(isPlaying: true, speed: 1.0);
        await _videoController?.play();
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
      setState(() {
        _state = _state.copyWith(
          showLoading: false,
          showEmpty: false,
          title: media.name,
          sentenceStates: sentenceStates,
          focusedIndex: () => sentenceStates.isEmpty ? null : 0,
        );
      });
    });
    _subs.add(sub);
  }

  void _onPositionChanged(VideoPlayerController videoController) async {
    final media = _media;
    if (media == null) {
      debugPrint('media not found');
      return;
    }
    final subtitle = media.subtitles.firstOrNull;
    if (subtitle == null) {
      debugPrint('no subtitle to spot');
      return;
    }
    if (subtitle.sentences.isEmpty) {
      debugPrint('no sentence to spot');
      return;
    }
    final position = videoController.value.position;
    final sentences = subtitle.sentences;
    final mediaEnd = videoController.value.duration;

    final repeatIndex = _state.repeatIndex;
    debugPrint('positon changed: loop index: $repeatIndex');
    if (repeatIndex != null) {
      final nextSentence = sentences.elementAtOrNull(repeatIndex + 1);
      final bool needToSeekToBeginning;
      if (nextSentence != null) {
        needToSeekToBeginning = position >= nextSentence.start;
      } else {
        needToSeekToBeginning = position >= mediaEnd;
      }
      if (needToSeekToBeginning) {
        await videoController.seekTo(
          _startPositionForPlayingSentence(repeatIndex),
        );
      }
    } else {
      final focusedIndex = _state.focusedIndex;
      if (focusedIndex == null) {
        debugPrint('focus index not found');
        return;
      }
      final int? playingIndex;
      //从当前sentence开始判断这句是不是真的在播放中
      //从现在的 index，判断到最后，再从最前的index，判断到现在的index
      final allRange = List.generate(sentences.length, (index) => index);
      final range1 = allRange.sublist(focusedIndex);
      final range2 = allRange.sublist(0, focusedIndex);
      final searchRange = [...range1, ...range2];
      playingIndex = searchRange.firstWhereOrNull(
        (idx) => _isSentencePlaying(idx, position, mediaEnd),
      );
      if (playingIndex == null) {
        debugPrint('playing index not found');
        return;
      }
      if (playingIndex != focusedIndex) {
        _scrollController.jumpTo(index: playingIndex, alignment: 0.3);
        setState(() {
          _state = _state.copyWith(focusedIndex: () => playingIndex);
        });
      }
    }
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    final milliseconds = (d.inMilliseconds.remainder(1000) ~/ 100).toString();
    return '$minutes:$seconds.$milliseconds';
  }

  bool _isSentencePlaying(
    int sentenceIndex,
    Duration position,
    Duration mediaEnd,
  ) {
    final sentences = _media?.subtitles.firstOrNull?.sentences;
    if (sentences == null || sentences.isEmpty) return false;
    if (sentences.length == 1) return true;

    final sentence = sentences.elementAtOrNull(sentenceIndex);
    if (sentence == null) return false;
    final nextSentence = sentences.elementAtOrNull(sentenceIndex + 1);
    final prevSentence = sentenceIndex == 0
        ? null
        : sentences[sentenceIndex - 1];
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
    // if (sentenceIndex == 0) {
    //   if (nextSentence == null) {
    //     return true;
    //   } else {
    //     return const Duration(microseconds: 0) <= position &&
    //         position < nextSentence.start;
    //   }
    // } else if (sentenceIndex == sentences.length - 1) {
    //   return sentence.start <= position && position <= mediaEnd;
    // } else {
    //   if (nextSentence == null) {
    //     return sentence.start <= position && position < mediaEnd;
    //   } else {
    //     return sentence.start <= position && position < nextSentence.start;
    //   }
    // }
  }

  @override
  void dispose() {
    _cancelAllSubs();
    _videoController?.dispose();
    super.dispose();
  }

  void _cancelAllSubs() {
    for (final sub in _subs) {
      sub.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PlayerUI(_state, this, _videoController, _scrollController);
  }

  @override
  void player_onInOrder() {
    setState(() {
      _state = _state.copyWith(repeatIndex: () => _state.focusedIndex);
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
    _scrollController.jumpTo(index: index, alignment: 0.3);
    final toPosition = _startPositionForPlayingSentence(index);
    debugPrint('seeked to $toPosition');
    final repeatIndex = _state.repeatIndex == null ? null : index;
    setState(() {
      _state = _state.copyWith(
        focusedIndex: () => index,
        repeatIndex: () => repeatIndex,
        isPlaying: true,
      );
    });
    await videoController.seekTo(toPosition);
    await videoController.play();
  }

  Duration _startPositionForPlayingSentence(int sentenceIndex) {
    final sentences = _media!.subtitles.first.sentences;
    if (sentenceIndex == 0) {
      return const Duration(microseconds: 0);
    } else {
      return sentences[sentenceIndex].start;
    }
  }
}
