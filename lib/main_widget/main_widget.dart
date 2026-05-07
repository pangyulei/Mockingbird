import 'package:flutter/material.dart';
import 'package:mockingbird/main_widget/main_widget_events.dart';
import 'package:mockingbird/main_widget/main_widget_state.dart';

class MainWidget extends StatefulWidget {
  final MainWidgetEvents handler;
  const MainWidget({required this.handler, super.key});

  @override
  State<MainWidget> createState() => _MainWidgetFactory();
}

class _MainWidgetFactory extends State<MainWidget> {
  late MainWidgetState _state;

  @override
  void initState() {
    super.initState();
    _state = widget.handler.mainWidgetInitState();
  }

  void _updateState(MainWidgetState newState) {
    setState(() {
      _state = newState;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: const Icon(Icons.login),
          centerTitle: false,
          title: const Text('Default'),
          actions: const [Text('action 1'), Icon(Icons.login)],
          backgroundColor: Colors.blue,
        ),
        // drawer: Drawer(), //must disable appbar's leading
        body: _state.bodyWidget, //const Center(child: Text('Hello World!')),
        bottomNavigationBar: NavigationBar(
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.playlist_play_rounded),
              label: '',
            ),
            NavigationDestination(
              icon: Icon(Icons.play_circle_rounded),
              label: '',
            ),
            NavigationDestination(
              icon: Icon(Icons.settings_rounded),
              label: '',
            ),
          ],
          onDestinationSelected: (int selectedIndex) {
            MainWidgetState newState = widget.handler
                .mainWidgetBottomBarSelectedIndex(
                  state: _state,
                  selectedIndex: selectedIndex,
                );
            _updateState(newState);
          },
          selectedIndex: _state.bottomBarSelectedIndex,
          backgroundColor: const Color.fromARGB(0, 0, 0, 0),
        ),
      ),
    );
  }
}
