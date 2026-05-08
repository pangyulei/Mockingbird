import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../objectbox.g.dart'; // created by `flutter pub run build_runner build`

class DB {
  static DB? _instance;
  late final Store _store;

  DB._create(this._store) {
    // Add any additional setup code, e.g. build queries.
  }

  static Store get store {
    return instance._store;
  }

  static DB get instance {
    if (_instance == null) {
      throw Exception('DB should init at main() and keep open, never null');
    }
    return _instance!;
  }

  /// Create an instance of ObjectBox to use throughout the app.
  static Future<DB> init() async {
    final docsDir = await getApplicationDocumentsDirectory();
    // Future<Store> openStore() {...} is defined in the generated objectbox.g.dart
    final store = await openStore(
      directory: p.join(docsDir.path, "db_objectbox"),
    );
    _instance = DB._create(store);
    return _instance!;
  }
}
