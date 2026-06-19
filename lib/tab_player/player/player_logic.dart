import 'dart:io';

import 'package:mockingbird/model/media.dart';
import 'package:mockingbird/model/sentence.dart';
import 'package:mockingbird/tab_player/player_sentence/player_sentence_state.dart';
import 'package:video_player/video_player.dart';
import 'player_interface_ui_events.dart';
import 'player_state.dart';
import '../../tool/subtitle_parser.dart';
import '../../models/subtitle.dart';

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
    _media = media;
    state = state.copyWith(
      title: media.name,
      showLoading: true,
      sentenceStates: media.subtitle.target?.sentences.asMap().entries.map((e) {
        int i = e.key;
        Sentence s = e.value;
        return PlayerSentenceState(
            isPlaying: i == 0,
            text: s.text,
            period: '${_formatDuration(s.start)} - ${_formatDuration(s.end)}',
        );
      }).toList(),
      playingSentenceIndex: media.subtitle.target == null ? null : 0,
    );
    yield state;

    //load media
    await state.playerController?.dispose();
    final playerController = VideoPlayerController.file(File(media.pathStr));
    await playerController.initialize();
    state = state.copyWith(playerController: playerController);
    yield state;

    // Auto play
    await playerController.play();
  }

  @override
  PlayerState playerUpdatePosition(PlayerState state, Duration position) {
    if (state.sentences.isEmpty) return state;

    final index = state.sentences.indexWhere(
      (s) => position >= s.start && position <= s.end,
    );

    if (index != -1 && index != state.playingSentenceIndex) {
      return state.copyWith(currentSentenceIndex: index);
    }
    
    // If we are between sentences, we might want to keep the last one or clear it
    // For shadowing, it might be better to keep the last one visible until the next starts
    // But indexWhere returns -1 if not found.
    return state;
  }
}
