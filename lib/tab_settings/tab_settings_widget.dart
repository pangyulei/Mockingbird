import 'package:flutter/material.dart';

class TabSettingsWidget extends StatelessWidget {
  const TabSettingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: const Center(child: Text('Settings Content')),
    );
  }
}
