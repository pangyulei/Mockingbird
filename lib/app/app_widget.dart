import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mockingbird/app/app_events.dart';
import 'package:mockingbird/app/app_state.dart';
import 'package:mockingbird/tab_play/tab_play_widget.dart';
import 'package:mockingbird/tab_playlists/tab_playlists/tab_playlists_logic.dart';
import 'package:mockingbird/tab_playlists/tab_playlists/tab_playlists_widget.dart';
import 'package:mockingbird/tab_settings/tab_settings_widget.dart';

class AppWidget extends StatefulWidget {
  final AppEvents _handler;
  const AppWidget(this._handler, {super.key});

  @override
  State<AppWidget> createState() => _AppWidgetFactory();
}

class _AppWidgetFactory extends State<AppWidget> {
  late AppState _state;

  @override
  void initState() {
    super.initState();
    _state = widget._handler.appWidgetInitState();
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
      theme: ThemeData(
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
      ),
      home: Scaffold(
        body: IndexedStack(
          index: _state.tabIdx,
          children: const [
            TabPlaylistsWidget(TabPlaylistsLogic()),
            TabPlayWidget(),
            TabSettingsWidget(),
          ],
        ),
        bottomNavigationBar: _buildTabBar(),
      ),
    );
  }

  Widget _buildTabBar() {
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
        AppState newState = widget._handler.appWidgetBottomBarSelectedIndex(
          _state,
          index,
        );
        _updateState(newState);
      },
      selectedIndex: _state.tabIdx,
    );
  }
}
