import 'dart:io';

import 'package:mockingbird/models/track.dart';
import 'package:video_player/video_player.dart';
import 'player_interface_ui_events.dart';
import 'player_state.dart';
import 'subtitle_parser.dart';
import '../../models/subtitle_sentence.dart';

class PlayerLogic implements PlayerInterfaceUIEvents {
  Track? _track;
  PlayerLogic({this._track});

  @override
  Stream<PlayerState> playerPlayTrack(PlayerState state, Track track) async* {
    _track = track;
    state = state.copyWith(
      title: track.name,
      showLoading: true,
      sentences: [],
      currentSentenceIndex: -1,
    );
    yield state;

    //load media
    await state.playerController?.dispose();
    final playerController = VideoPlayerController.file(File(track.pathStr));
    await playerController.initialize();
    state = state.copyWith(playerController: playerController);
    yield state;

    //load subtitle
    List<SubtitleSentence> sentences = [];
    if (_track!.subPathStr != null) {
      sentences = await SubtitleParser.parse(_track!.subPathStr!);
    }
    
    yield state.copyWith(showLoading: false, sentences: sentences);
    
    // Auto play
    await playerController.play();
  }

  @override
  PlayerState playerUpdatePosition(PlayerState state, Duration position) {
    if (state.sentences.isEmpty) return state;

    final index = state.sentences.indexWhere(
      (s) => position >= s.start && position <= s.end,
    );

    if (index != -1 && index != state.currentSentenceIndex) {
      return state.copyWith(currentSentenceIndex: index);
    }
    
    // If we are between sentences, we might want to keep the last one or clear it
    // For shadowing, it might be better to keep the last one visible until the next starts
    // But indexWhere returns -1 if not found.
    return state;
  }
}
