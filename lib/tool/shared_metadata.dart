import 'package:mockingbird/db/db.dart';
import 'package:mockingbird/db/entities/metadata_entity.dart';

class SharedMetadata {
  static late MetadataEntity instance;
  static Future<void> init() async {
    instance = await DB.loadMetadata();
  }
}
