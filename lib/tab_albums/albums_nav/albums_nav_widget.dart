import 'package:flutter/material.dart';
import 'albums_nav_interface_ui_events.dart';

class AlbumsNavWidget extends StatelessWidget {
  final AlbumsNavInterfaceUIEvents _logic;
  const AlbumsNavWidget(this._logic, {super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: _logic.albumsNavOnGenerateRoute,
      onGenerateInitialRoutes: _logic.albumsNavOnGenerateInitialRoute,
    );
  }
}
