import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_kit/media_kit.dart';
import 'package:mockingbird/app/app_ui.dart';
import 'package:mockingbird/db/db_objectbox.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); //objectbox official code
  MediaKit.ensureInitialized();
  await DBObjectBox.init();
  runApp(const ProviderScope(child: AppUI()));
}
