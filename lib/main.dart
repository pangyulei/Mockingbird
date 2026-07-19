import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockingbird/app/app_ui.dart';
import 'package:mockingbird/db/db_objectbox.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); //objectbox official code
  await DBObjectBox.init();
  runApp(const ProviderScope(child: AppUI()));
}
