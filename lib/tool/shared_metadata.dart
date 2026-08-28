import 'package:mockingbird/db/db.dart';
import 'package:mockingbird/db/entities/metadata_entity.dart';

class SharedMetadata {
  static late MetadataEntity instance;
  static Future<void> init() async {
    assert(instance == null, 'call init while app preparing at main');
    instance = await DB.loadMetadata();
  }
}
