import 'package:mockingbird/db/db.dart';
import 'package:mockingbird/db/entities/metadata_entity.dart';
import 'package:mockingbird/tool/event_hub.dart';

class SharedMetadata {
  static late MetadataEntity instance;
  static Future<void> init() async {
    instance = await DB.loadMetadata();
    EventHub.on<HubAppPauseEvent>((event) async {
      await DB.updateMetadata(instance);
    });
  }
}
