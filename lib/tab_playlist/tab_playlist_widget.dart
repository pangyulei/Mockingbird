import 'package:flutter/material.dart';
import 'package:mockingbird/tab_playlist/playlist/playlist_handler.dart';
import 'package:mockingbird/tab_playlist/playlist/playlist_widget.dart';
import 'package:mockingbird/tab_playlist/playlists/playlists/playlists_widget.dart';
import 'package:mockingbird/tab_playlist/tab_playlist_route.dart';

import 'playlists/playlists/playlists_handler.dart';

class TabPlaylistWidget extends StatelessWidget {
  const TabPlaylistWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) {
        if (settings.name != null) {
          _buildWidgetByURLStr(settings.name!);
        }
        return null;
      },
      onGenerateInitialRoutes: (navigator, initialRoute) {
        return [
              TabPlaylistRoute.urlStrForPlaylists(),
              // TabPlaylistRoute.urlStrForPlaylist(
              //   'default',
              // ), //TODO not 100% is default, may edited name
            ]
            .map((urlStr) => _buildWidgetByURLStr(urlStr))
            .toList(); 
      },
    );
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
            segments.first == TabPlaylistRoute.playlists) {
          return PlaylistsWidget(PlaylistsHandler());

        } else if (segments.length == 2) {
          final playlistIdStr = segments.last;
          final playlistId = int.tryParse(playlistIdStr);
          if (playlistId != null) {
            return PlaylistWidget(playlistId, PlaylistHandler());
          }
          throw Exception('Invalid playlist ID: $playlistIdStr');
        }
        throw Exception('$urlStr is not defined');
      },
    );
  }
}

// class TabPlaylistWidget extends StatefulWidget {
//   const TabPlaylistWidget({super.key});

//   @override
//   State<TabPlaylistWidget> createState() => _TabPlaylistWidgetFactory();
// }

// class _TabPlaylistWidgetFactory extends State<TabPlaylistWidget> {
//   @override
//   Widget build(BuildContext context) {
//     return Navigator(
//       onGenerateRoute: (settings) {
//         return null;
//       },
//       onGenerateInitialRoutes: (navigator, initialRoute) {
//         return [];
//       },
//     );
//   }
// }
