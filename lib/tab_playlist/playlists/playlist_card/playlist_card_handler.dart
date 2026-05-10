import 'package:mockingbird/models/playlist.dart';
import 'package:mockingbird/tab_playlist/playlists/playlist_card/playlist_card_events.dart';
import 'package:mockingbird/tab_playlist/playlists/playlist_card/playlist_card_state.dart';

class PlaylistCardHandler implements PlaylistCardEvents {
  @override
  PlaylistCardState playlistCardWidgetPressedStateChanged(PlaylistCardState state, bool isPressed) {
    return state.copyWith(isPressed: isPressed);
  }

  @override
  void playlistCardWidgetOnTap(Playlist playlist) {
    //TODO route to detail use route 
  }
}
