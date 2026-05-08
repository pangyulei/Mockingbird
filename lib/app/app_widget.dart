import 'package:flutter/material.dart';
import 'package:mockingbird/app/app_events.dart';
import 'package:mockingbird/app/app_state.dart';
import 'package:mockingbird/tab_play/tab_play_widget.dart';
import 'package:mockingbird/tab_playlist/tab_playlist_widget.dart';
import 'package:mockingbird/tab_setting/tab_setting_widget.dart';

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
      home: Scaffold(
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
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.playlist_play_rounded),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.play_circle_rounded),
          label: '',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.settings_rounded), label: ''),
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
