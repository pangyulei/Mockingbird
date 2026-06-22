import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:mockingbird/model/media.dart';
import 'package:mockingbird/model/sentence.dart';
import 'package:mockingbird/tab_player/player/sentence_card/sentence_card_state.dart';
import 'package:scrollable_positioned_list/src/scrollable_positioned_list.dart';
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
      playingSentenceIndex: () => sentenceStates.isEmpty ? null : 0,
      isLoop1: false,
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
  PlayerState playerPositionChanged(PlayerState state, Duration position) {
    //auto scroll subtitle sentences
    if (_media == null) return state;
    if (_media!.subtitles.isEmpty) return state;
    final subtitle = _media!.subtitles.first;
    final sentences = subtitle.sentences;
    if (sentences.isEmpty) return state;

    var newPlayingIndex = state.playingSentenceIndex!;
    if (state.isLoop1) {
      final sentence = sentences[newPlayingIndex];
      if (position > sentence.end) {
        state.videoController!.seekTo(sentence.start);
      }
      return state;

    } else {
      //刚开始的时候position=0,但是第一句话的start不一定是0
      //所以当position=0的时候，就不处于任何一句话的区间，这里直接做个判断就省了后面的几百句话的遍历
      // if (position <= sentences[0].end) return state.copyWith(playingSentenceIndex: () => 0);
      if (position <= sentences[0].end) {
        newPlayingIndex = 0;
      } else {
        //从当前sentence开始判断这句是不是真的在播放中
        final sentencesWithIndex = sentences.asMap().entries;
        try {
          final s = sentencesWithIndex
              .skip(state.playingSentenceIndex!)
              .firstWhere((s) => _isSentencePlaying(s.value, position));
          newPlayingIndex = s.key;
        } catch (e1) {
          // debugPrint(e1.toString());
          try {
            final s = sentencesWithIndex
                .skipWhile((s) => s.key >= state.playingSentenceIndex!)
                .firstWhere((s) => _isSentencePlaying(s.value, position));
            newPlayingIndex = s.key;
          } catch (e2) {
            // debugPrint(e2.toString());
          }
        }
      }
      if (newPlayingIndex != state.playingSentenceIndex) {
        _scrollController.jumpTo(index: newPlayingIndex, alignment: 0.3);
        return state.copyWith(playingSentenceIndex: () => newPlayingIndex);
      } else {
        return state;
      }
    }
  }

  bool _isSentencePlaying(Sentence s, Duration position) {
    final start = s.start;
    final end = s.end;
    final matched = start <= position && position <= end;
    return matched;
  }

  @override
  PlayerState playerPlaySentence(PlayerState state, int index) {
    assert(state.videoController!=null);
    assert(_media != null);
    assert(_media!.subtitles.isNotEmpty);
    assert(_media!.subtitles.first.sentences.isNotEmpty);

    final sentence = _media!.subtitles.first.sentences[index];
    state.videoController!.seekTo(sentence.start);
    state.videoController!.play();
    return state;
  }

  @override
  ItemScrollController get playerScrollController => _scrollController;

}
