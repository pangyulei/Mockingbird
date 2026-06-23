import 'dart:io';

import 'package:flutter/widget_previews.dart';
import 'package:flutter/widgets.dart';
import 'package:mockingbird/model/media.dart';
import 'package:mockingbird/model/sentence.dart';
import 'package:mockingbird/tab_player/player/sentence_card/sentence_card_state.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:video_player/video_player.dart';
import 'player_interface_ui_events.dart';
import 'player_state.dart';

class PlayerLogic implements PlayerInterfaceUIEvents {
  final _scrollController = ItemScrollController();
  Media? _media;
  PlayerLogic({this._media});


  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    final milliseconds = (d.inMilliseconds.remainder(1000) ~/ 100).toString();
    return '$minutes:$seconds.$milliseconds';
  }

  @override
  Stream<PlayerState> playerPlayMedia(PlayerState state, Media media) async* {
    if (_media != null && _media!.id == media.id) {
      yield state;
      return;
    }
    final sentences = media.subtitles.firstOrNull?.sentences;
    final sentenceStates = sentences?.asMap().entries.map((e) {
      int i = e.key;
      Sentence s = e.value;
      return SentenceCardState(
        isPlaying: i == 0,
        text: s.text,
        period: '${_formatDuration(s.start)} - ${_formatDuration(s.end)}',
        index: i,
      );
    }).toList() ?? const [];
    state = state.copyWith(
      title: media.name,
      showLoading: true,
      showEmpty: true,
      sentenceStates: sentenceStates,
      highlightedIndex: () => sentenceStates.isEmpty ? null : 0,
      loopIndex: null,
    );
    yield state;

    //load media
    if (_media?.path != media.path) {
      await state.videoController?.dispose();
      final videoController = VideoPlayerController.file(File(media.path));
      await videoController.initialize();
      state = state.copyWith(videoController: videoController);

    }
    yield state.copyWith(showLoading: false, showEmpty: false);

    // Auto play
    _media = media;
    await state.videoController?.play();
  }

  @override
  Future<PlayerState> playerPositionChanged(PlayerState state, Duration position) async {
    //auto scroll subtitle sentences
    if (_media == null) return state;
    if (_media!.subtitles.isEmpty) return state;
    final subtitle = _media!.subtitles.first;
    final sentences = subtitle.sentences;
    if (sentences.isEmpty) return state;
    final mediaEnd = state.videoController!.value.duration;

    if (state.loopIndex != null) {
      final index = state.loopIndex!;
      final nextSentence = index+1 < sentences.length ? sentences[index+1] : null;
      bool needToSeekToBeginning = false;
      if (nextSentence != null) {
        needToSeekToBeginning = position >= nextSentence.start;
      } else {
        needToSeekToBeginning = position >= mediaEnd;
      }
      if (needToSeekToBeginning) {
        await state.videoController!.seekTo(_startPositionForPlayingSentence(index));
      }
      if (index != state.highlightedIndex) {
        _scrollController.jumpTo(index: index, alignment: 0.3);
      }
      return state.copyWith(highlightedIndex: () => index);

    } else {
      int? currentPlayingIndex;

      //从当前sentence开始判断这句是不是真的在播放中
      final sentencesWithIndex = sentences.asMap().entries;
      //从现在的 index，判断到最后，再从最前的index，判断到现在的index
      final allRange = List.generate(sentences.length, (index)=>index);
      final range1 = allRange.sublist(state.highlightedIndex!);
      final range2 = allRange.sublist(0, state.highlightedIndex!);
      final searchRange = [...range1, ...range2];
      for (var i in searchRange) {
        if (_isSentencePlaying(i, position, mediaEnd)) {
          currentPlayingIndex = i;
          break;
        }
      }
      if (currentPlayingIndex == null) {
        assert(false, 'player should always find an sentence for current playing position');
        return state;
      }
      if (currentPlayingIndex != state.highlightedIndex) {
        _scrollController.jumpTo(index: currentPlayingIndex, alignment: 0.3);
      }
      return state.copyWith(highlightedIndex: () => currentPlayingIndex);
    }

  }

  bool _isSentencePlaying(int sentenceIndex, Duration position, Duration mediaEnd) {
    final sentences = _media!.subtitles.first.sentences;
    if (sentences.length == 1) {
      return true;
    }
    final nextSentence = sentenceIndex+1 < sentences.length ? sentences[sentenceIndex+1] : null;
    final sentence = sentences[sentenceIndex];

    //刚开始的时候position=0,但是第一句话的start不一定是0
    //所以当position=0的时候，就不处于任何一句话的区间，这里直接做个判断就省了后面的几百句话的遍历
    if (sentenceIndex == 0) {
      return const Duration(microseconds: 0) <= position && position < nextSentence!.start;

    } else if (sentenceIndex == sentences.length-1) {
      return sentence.start <= position && position <= mediaEnd;

    } else {
      return sentence.start <= position && position < nextSentence!.start;
    }

  }

  @override
  Future<PlayerState> playerPlaySentence(PlayerState state, int index) async {
    assert(state.videoController!=null);
    assert(_media != null);
    assert(_media!.subtitles.isNotEmpty);
    assert(_media!.subtitles.first.sentences.isNotEmpty);

    final sentences = _media!.subtitles.first.sentences;
    final sentence = sentences[index];
    if (state.loopIndex != null) {
      state = state.copyWith(loopIndex: () => index);
    }
    await state.videoController!.seekTo(_startPositionForPlayingSentence(index));
    await state.videoController!.play();
    return state.copyWith(highlightedIndex: () => index);
  }

  Duration _startPositionForPlayingSentence(int sentenceIndex) {
    final sentences = _media!.subtitles.first.sentences;
    if (sentenceIndex == 0) {
      return const Duration(microseconds: 0);
    } else {
      return sentences[sentenceIndex].start;
    }
  }

  @override
  ItemScrollController get playerScrollController => _scrollController;

}
