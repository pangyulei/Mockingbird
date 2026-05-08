import 'package:flutter/material.dart';
import 'package:mockingbird/app/app_handler.dart';
import 'package:mockingbird/app/app_widget.dart';
import 'package:mockingbird/db/db.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); //objectbox official code
  await DB.init();
  runApp(const AppWidget(AppHandler()));
}
