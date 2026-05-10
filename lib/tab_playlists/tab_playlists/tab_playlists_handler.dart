import 'package:flutter/material.dart';
import 'package:mockingbird/tab_playlists/playlist/playlist_handler.dart';
import 'package:mockingbird/tab_playlists/playlist/playlist_widget.dart';
import 'package:mockingbird/tab_playlists/playlists_list/playlists_list_handler.dart';
import 'package:mockingbird/tab_playlists/playlists_list/playlists_list_widget.dart';
import 'package:mockingbird/tab_playlists/tab_playlists/tab_playlists_events.dart';

import 'tab_playlists_route.dart';

class TabPlaylistsHandler implements TabPlaylistsEvents {
  const TabPlaylistsHandler();

  @override
  Route<dynamic>? tabPlaylistsOnGenerateRoute(RouteSettings settings) {
    if (settings.name != null) {
      return _buildWidgetByURLStr(settings.name!);
    } else {
      return null;
    }
  }

  Route<dynamic> _buildWidgetByURLStr(String urlStr) {
    /*
    /playlists           -> playlist list page
    /playlists/42        -> playlist songs
    /playlists/42/edit   -> edit playlist
      */
    return MaterialPageRoute(
      builder: (context) {
        final uri = Uri.parse(urlStr);
        // ['playlists', '42']
        final segments = uri.pathSegments;
        if (segments.length == 1 &&
            segments.first == TabPlaylistsRoute.playlists) {
          return const PlaylistsListWidget(PlaylistsListHandler());
        } else if (segments.length == 2 &&
            segments.first == TabPlaylistsRoute.playlists) {
          final playlistIdStr = segments.last;
          final playlistId = int.tryParse(playlistIdStr);
          if (playlistId != null) {
            return PlaylistWidget(playlistId, const PlaylistHandler());
          } else {
            throw Exception('Invalid playlist ID: $playlistIdStr');
          }
        } else {
          throw Exception('$urlStr is not defined');
        }
      },
    );
  }

  @override
  List<Route<dynamic>> tabPlaylistsOnGenerateInitialRoute(
    NavigatorState navigator,
    String initialRoute,
  ) {
    return [
      TabPlaylistsRoute.urlStrForPlaylists(),
      // TabPlaylistRoute.urlStrForPlaylist(
      //   'default',
      // ), //TODO not 100% is default, may edited name
    ].map((urlStr) => _buildWidgetByURLStr(urlStr)).toList();
  }
}
