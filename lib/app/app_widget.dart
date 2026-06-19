import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mockingbird/app/app_interface_ui_events.dart';
import 'package:mockingbird/app/app_state.dart';
import 'package:mockingbird/tab_player/player_nav/player_nav_logic.dart';
import 'package:mockingbird/tab_player/player_nav/player_nav_widget.dart';
import 'package:mockingbird/tab_playlists/playlists_nav/playlists_nav_logic.dart';
import 'package:mockingbird/tab_playlists/playlists_nav/playlists_nav_widget.dart';
import 'package:mockingbird/tab_settings/tab_settings_widget.dart';

import '../tool/global_broadcaster.dart';

class AppWidget extends StatefulWidget {
  final AppInterfaceUIEvents _logic;
  const AppWidget(this._logic, {super.key});

  @override
  State<AppWidget> createState() => _AppWidgetFactory();
}

class _AppWidgetFactory extends State<AppWidget> {
  AppState _state = const AppState(AppTab.playlists);
  final List<StreamSubscription> _subs = [];

  @override
  void initState() {
    super.initState();
    _subs.add(GlobalBroadcaster.instance.on<GlobalEventPlayMedia>((event) {
      _updateState(widget._logic.appSwitchToTab(_state, .player));
    }));
  }
  
  @override
  void dispose() {
    for (final sub in _subs) {
      sub.cancel();
    }
    super.dispose();
  }

  void _updateState(AppState newState) {
    setState(() {
      _state = newState;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _theme(),
      home: _home(),
    );
  }

  Widget _home() {
    return Scaffold(
      body: IndexedStack(
        index: _state.selectedTab.raw,
        children: const [
          PlaylistsNavWidget(PlaylistsNavLogic()),
          PlayerNavWidget(PlayerNavLogic()),
          TabSettingsWidget(),
        ],
      ),
      bottomNavigationBar: _tabBar(),
    );
  }

  Widget _tabBar() {
    return NavigationBar(
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.playlist_play_outlined),
          selectedIcon: Icon(Icons.playlist_play),
          label: 'Playlists',
        ),
        NavigationDestination(
          icon: Icon(Icons.play_circle_outline),
          selectedIcon: Icon(Icons.play_circle),
          label: 'Player',
        ),
        NavigationDestination(
          icon: Icon(Icons.settings_outlined),
          selectedIcon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
      onDestinationSelected: (index) {
        _updateState(widget._logic.appSwitchToTab(_state, AppTab.fromRaw(index)));
      },
      selectedIndex: _state.selectedTab.raw,
    );
  }

  ThemeData _theme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF005691),
        brightness: Brightness.light,
        primary: const Color(0xFF005691),
        onPrimary: Colors.white,
        surface: Colors.white,
        onSurface: const Color(0xFF191C1E),
      ),
      scaffoldBackgroundColor: Colors.white,
      textTheme: GoogleFonts.interTextTheme(
        const TextTheme(
          titleLarge: TextStyle(color: Color(0xFF191C1E), fontWeight: FontWeight.bold),
          titleMedium: TextStyle(color: Color(0xFF191C1E), fontWeight: FontWeight.w600),
          bodyLarge: TextStyle(color: Color(0xFF191C1E)),
          bodyMedium: TextStyle(color: Color(0xFF42474E)),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Color(0xFF191C1E),
        elevation: 0,
        scrolledUnderElevation: 2,
      ),
    );
  }
}
