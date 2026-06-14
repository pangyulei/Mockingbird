import 'package:flutter/material.dart';
import 'package:mockingbird/tab_player/player/player_logic.dart';
import 'package:mockingbird/tab_player/player/player_widget.dart';
import 'package:mockingbird/tab_player/player_nav/player_nav_interface_ui_events.dart';
import 'package:mockingbird/tab_player/player_nav/player_nav_route.dart';

class PlayerNavLogic implements PlayerNavInterfaceUIEvents {
  const PlayerNavLogic();

  @override
  Route<dynamic>? playerNavOnGenerateRoute(RouteSettings settings) {
    if (settings.name != null) {
      return _widgetByURLStr(settings.name!);
    } else {
      return null;
    }
  }

  Route<dynamic> _widgetByURLStr(String urlStr) {
    return MaterialPageRoute(
      builder: (context) {
        final uri = Uri.parse(urlStr);
        final segments = uri.pathSegments;
        if (segments.length == 1 &&
            segments.first == PlayerNavRoute.player) {
          return PlayerWidget(PlayerLogic());
        } else {
          throw Exception('$urlStr is not defined');
        }
      },
    );
  }

  @override
  List<Route<dynamic>> playerNavOnGenerateInitialRoute(
    NavigatorState navigator,
    String initialRoute
  ) {
    return [
      PlayerNavRoute.urlStrForPlayer(),
    ].map((urlStr) => _widgetByURLStr(urlStr)).toList();
  }
}
