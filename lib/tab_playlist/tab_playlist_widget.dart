import 'package:flutter/material.dart';
import 'package:mockingbird/tab_playlist/playlist/playlist_widget.dart';
import 'package:mockingbird/tab_playlist/playlists/playlists_widget.dart';
import 'package:mockingbird/tab_playlist/tab_playlist_route.dart';

class TabPlaylistWidget extends StatelessWidget {
  const TabPlaylistWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) {
        if (settings.name != null) {
          _buildWidgetByURLString(settings.name!);
        } else {
          return null;
        }
        return null;
      },
      onGenerateInitialRoutes: (navigator, initialRoute) {
        return [
          TabPlaylistRoute.urlStringForPlaylists(),
          // TabPlaylistRoute.urlStringForPlaylist(
          //   'default',
          // ), //TODO not 100% is default, may edited name
        ].map((urlString) => _buildWidgetByURLString(urlString)).toList();
      },
    );
  }

  Route<dynamic> _buildWidgetByURLString(String urlString) {
    /*
    /playlists           -> playlist list page
    /playlists/42        -> playlist songs
    /playlists/42/edit   -> edit playlist
      */
    return MaterialPageRoute(
      builder: (context) {
        final uri = Uri.parse(urlString);
        // ['playlists', '42']
        final segments = uri.pathSegments;
        if (segments.length == 1 &&
            segments.first == TabPlaylistRoute.playlists) {
          return const PlaylistsWidget();
        } else if (segments.length == 2) {
          String playlistName = segments.last; //TODO
          return PlaylistWidget(playlistName);
        } else {
          throw Exception('$urlString is not defined');
        }
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
