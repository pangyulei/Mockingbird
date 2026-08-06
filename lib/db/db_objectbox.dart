import 'package:flutter/foundation.dart';
import 'package:mockingbird/objectbox.g.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class DBObjectBox {
  static DBObjectBox? _instance;
  final Store store;

  const DBObjectBox._(this.store);
  // static DBObjectBox get instance {}
  factory DBObjectBox() {
    final instance = _instance;
    if (instance == null) {
      throw StateError('you must init dbobjectbox in main');
    } else {
      return instance;
    }
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
