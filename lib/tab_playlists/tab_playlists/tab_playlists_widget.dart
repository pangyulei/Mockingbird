import 'package:flutter/material.dart';
import 'package:mockingbird/tab_playlists/tab_playlists/tab_playlists_interface_ui_events.dart';

class TabPlaylistsWidget extends StatelessWidget {
  final TabPlaylistsInterfaceUIEvents _handler;
  const TabPlaylistsWidget(this._handler, {super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: _handler.tabPlaylistsOnGenerateRoute,
      onGenerateInitialRoutes: _handler.tabPlaylistsOnGenerateInitialRoute,
    );
  }
}
