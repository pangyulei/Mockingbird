import 'package:flutter/material.dart';
import 'playlists_nav_interface_ui_events.dart';

class PlaylistsNavWidget extends StatelessWidget {
  final PlaylistsNavInterfaceUIEvents _logic;
  const PlaylistsNavWidget(this._logic, {super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: _logic.playlistsNavOnGenerateRoute,
      onGenerateInitialRoutes: _logic.playlistsNavOnGenerateInitialRoute,
    );
  }
}
