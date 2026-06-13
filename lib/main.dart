import 'package:flutter/material.dart';
import 'package:mockingbird/app/app_logic.dart';
import 'package:mockingbird/app/app_widget.dart';
import 'package:mockingbird/db/objectbox.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); //objectbox official code
  await ObjectBox.init();
  runApp(const AppWidget(AppLogic()));
}
