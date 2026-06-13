import 'package:flutter/material.dart';
import 'player_state.dart';
import 'player_logic.dart';

class PlayerWidget extends StatefulWidget {
  final PlayerLogic _logic;

  const PlayerWidget(this._logic, {super.key});

  @override
  State<PlayerWidget> createState() => _PlayerWidgetFactory();
}

class _PlayerWidgetFactory extends State<PlayerWidget> {
  PlayerState _state = const PlayerState();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<Notification>(
      onNotification: (notification) {
        final (res, state) = widget._logic.receiveNotification(_state, notification);
        _updateState(state);
        return res;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_state.track?.name ?? 'Player'),
        ),
        body: const Text("data"),
      ),
    );
  }

  void _updateState(PlayerState newState) {
    setState(() {
      _state = newState;
    });
  }
}
