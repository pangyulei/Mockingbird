import 'package:flutter/material.dart';
import 'package:mockingbird/app/app_events.dart';
import 'package:mockingbird/app/app_state.dart';
import 'package:mockingbird/tab_playlist/tab_playlist_widget.dart';

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
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF1E1F23),
      ),
      home: Scaffold(
        backgroundColor: const Color(0xFF1E1F23),
        body: IndexedStack(
          index: _state.index,
          children: const [
            TabPlaylistWidget(), //TODO
            // TabPlayWidget(),
            // TabSettingWidget(),
          ],
        ),
        bottomNavigationBar: _buildBottomNavigationBar(),
      ),
    );
  }

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      backgroundColor: const Color(0xFF1E1F23),
      selectedItemColor: const Color(0xFFFF4D00),
      unselectedItemColor: const Color(0xFF6A6C75),
      type: BottomNavigationBarType.fixed,
      elevation: 0,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.playlist_play),
          label: 'Playlists',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.play_circle),
          label: 'Player',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
      onTap: (index) {
        AppState newState = widget._handler.appWidgetBottomBarSelectedIndex(
          _state,
          index,
        );
        _updateState(newState);
      },
      currentIndex: _state.index,
    );
  }
}
