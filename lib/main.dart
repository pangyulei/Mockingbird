import 'package:flutter/material.dart';
import 'package:mockingbird/app/app_screen.dart';
import 'package:mockingbird/db/db_objectbox.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); //objectbox official code
  await DBObjectBox.init();
  runApp(const AppScreen());
}
