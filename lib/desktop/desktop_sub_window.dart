import 'package:collection/collection.dart';
import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter/material.dart';
import 'package:mockingbird/tool/extensions.dart';

const kSubWindowTypeKey = 'type';

enum SubWindowType {
  subtitle('subtitle'),
  about('about');

  final String raw;
  const SubWindowType(this.raw);
  factory SubWindowType.raw(String raw) {
    final type = SubWindowType.values.firstWhere((e) => e.raw == raw);
    return type;
  }
}

class DesktopSubWindow extends StatelessWidget {
  final String _id;
  final SubWindowType _type;

  const DesktopSubWindow({super.key, required this._id, required this._type});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Window ID: $_id'),
          actions: [
            // 子窗口主动关闭自身的按钮
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () async {
                final windowController = WindowController.fromWindowId(_id);
                await windowController.close();
              },
            ),
          ],
        ),
        body: _buildWindowBody(),
      ),
    );
  }

  Widget _buildWindowBody() {
    switch (_type) {
      case .subtitle:
        return const Center(
          child: Text(
            'Subtitle Floating Window Content',
            style: TextStyle(fontSize: 20, color: Colors.yellow),
          ),
        );
      case .about:
        return const Center(child: Text('About This Desktop App'));
    }
  }
}
