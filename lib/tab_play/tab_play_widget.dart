import 'package:flutter/material.dart';

class TabPlayWidget extends StatelessWidget {
  const TabPlayWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Player')),
      body: const Center(child: Text('Player Content')),
    );
  }
}
