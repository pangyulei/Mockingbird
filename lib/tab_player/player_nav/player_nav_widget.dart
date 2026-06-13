import 'package:flutter/material.dart';
import 'player_nav_interface_ui_events.dart';

class PlayerNavWidget extends StatelessWidget {
  final PlayerNavInterfaceUIEvents _logic;
  const PlayerNavWidget(this._logic, {super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: _logic.playerNavOnGenerateRoute,
      onGenerateInitialRoutes: _logic.playerNavOnGenerateInitialRoute,
    );
  }
}
