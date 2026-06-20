import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:mockingbird/model/media.dart';
import 'package:mockingbird/model/sentence.dart';
import 'package:mockingbird/tab_player/player/sentence_card/sentence_card_state.dart';
import 'package:video_player/video_player.dart';
import 'player_interface_ui_events.dart';
import 'player_state.dart';

class PlayerLogic implements PlayerInterfaceUIEvents {
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

    state = state.copyWith(
      title: media.name,
      showLoading: true,
      sentenceStates: media.subtitle.target?.sentences.asMap().entries.map((e) {
        int i = e.key;
        Sentence s = e.value;
        return SentenceCardState(
            isPlaying: i == 0,
            text: s.text,
            period: '${_formatDuration(s.start)} - ${_formatDuration(s.end)}',
            index: i,
        );
      }).toList(),
      playingSentenceIndex: media.subtitle.target == null ? null : 0,
    );
    yield state;

    //load media
    if (_media?.path != media.path) {
      await state.playerController?.dispose();
      final playerController = VideoPlayerController.file(File(media.path));
      await playerController.initialize();
      state = state.copyWith(playerController: playerController);
    }
    yield state.copyWith(showLoading: false);

    // Auto play
    _media = media;
    await state.playerController?.play();
  }

  @override
  PlayerState playerPositionChanged(PlayerState state, Duration position) {
    //auto scroll subtitle sentences
    if (_media?.subtitle.target == null || _media!.subtitle.target!.sentences.isEmpty) return state;
    assert(state.playingSentenceIndex != null, '如果字幕文件存在，index 初始化是从0开始的');
    final sentences = _media!.subtitle.target!.sentences;
    //刚开始的时候position=0,但是第一句话的start不一定是0
    //所以当position=0的时候，就不处于任何一句话的区间，这里直接做个判断就省了后面的几百句话的遍历
    if (position <= sentences[0].end) return state.copyWith(playingSentenceIndex: 0);
    final sentencesWithIndex = sentences.asMap().entries;
    var newPlayingIndex = state.playingSentenceIndex!;
    try {
      final s = sentencesWithIndex
          .skip(state.playingSentenceIndex!)
          .firstWhere((s) => _isSentencePlaying(s.value, position));
      newPlayingIndex = s.key;
    } catch (e1) {
      debugPrint(e1.toString());
      try {
        final s = sentencesWithIndex
            .skipWhile((s) => s.key >= state.playingSentenceIndex!)
            .firstWhere((s) => _isSentencePlaying(s.value, position));
        newPlayingIndex = s.key;
      } catch (e2) {
        debugPrint(e2.toString());
      }
    }
    if (newPlayingIndex != state.playingSentenceIndex) {
      debugPrint('newPlayingIndex: $newPlayingIndex');
      return state.copyWith(playingSentenceIndex: newPlayingIndex);
    } else {
      return state;
    }
  }

  bool _isSentencePlaying(Sentence s, Duration position) {
    final start = s.start;
    final end = s.end;
    final matched = start <= position && position <= end;
    if (matched) {
      debugPrint('start: $start, end: $end, position: $position');
    }
    return matched;
  }

  @override
  PlayerState playerPlaySentence(PlayerState state, int index) {
    final sentence = _media?.subtitle.target?.sentences[index];
    state.playerController?.seekTo(sentence!.start);
    state.playerController?.play();
    return state;
  }
}
