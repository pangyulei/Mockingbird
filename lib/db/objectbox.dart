import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../objectbox.g.dart'; // created by `flutter pub run build_runner build`

class ObjectBox {
  static ObjectBox? _instance;
  final Store store;

  ObjectBox._(this.store);

  static ObjectBox get instance {
    if (_instance == null) {
      throw Exception('DB should init at main() and keep open, never null');
    }
    return _instance!;
  }

  /// Create an instance of ObjectBox to use throughout the app.
  static Future<ObjectBox> init() async {
    final docsDir = await getApplicationDocumentsDirectory();
    // Future<Store> openStore() {...} is defined in the generated objectbox.g.dart
    final store = await openStore(
      directory: p.join(docsDir.path, "db_objectbox"),
    );
    _instance = ObjectBox._(store);
    return _instance!;
  }
}
