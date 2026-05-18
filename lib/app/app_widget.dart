import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mockingbird/app/app_events.dart';
import 'package:mockingbird/app/app_state.dart';
import 'package:mockingbird/tab_playlists/tab_playlists/tab_playlists_logic.dart';
import 'package:mockingbird/tab_playlists/tab_playlists/tab_playlists_widget.dart';

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
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
      ),
      home: Scaffold(
        body: IndexedStack(
          index: _state.tabIdx,
          children: const [
            TabPlaylistsWidget(TabPlaylistsLogic()), //TODO
            // TabPlayWidget(),
            // TabSettingWidget(),
          ],
        ),
        bottomNavigationBar: _buildTabBar(),
      ),
    );
  }

  Widget _buildTabBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFFFF6B35), // Hermes orange
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.playlist_play),
          label: 'Playlists',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.play_circle), label: 'Player'),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
      ],
      onTap: (index) {
        AppState newState = widget._handler.appWidgetBottomBarSelectedIndex(
          _state,
          index,
        );
        _updateState(newState);
      },
      currentIndex: _state.tabIdx,
    );
  }
}
