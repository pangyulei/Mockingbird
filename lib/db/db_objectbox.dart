import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../objectbox.g.dart'; // created by `flutter pub run build_runner build`

class DBObjectBox {
  static DBObjectBox? _instance;
  final Store store;

  const DBObjectBox._(this.store);
  // static DBObjectBox get instance {}
  factory DBObjectBox() {
    assert(_instance != null, 'You should definitely call await init() method at main.dart, make sure db prepared.');
    return _instance!;
  }

  /// Create an instance of ObjectBox to use throughout the app.
  static Future<void> init() async {
    final appDir = await getApplicationDocumentsDirectory();
    // Future<Store> openStore() {...} is defined in the generated objectbox.g.dart
    final store = await openStore(
      directory: p.join(appDir.path, "db_objectbox"),
    );
    if (kDebugMode) {
      if (Admin.isAvailable()) {
        Admin(store);
      } else {
        debugPrint('ObjectBox Admin is NOT available');
      }
    }
    _instance = DBObjectBox._(store);
  }
}
