import 'package:flutter/rendering.dart';
import 'package:mockingbird/db/db.dart';
import 'package:mockingbird/db/entities/metadata_entity.dart';
import 'package:mockingbird/tool/event_hub.dart';

class SharedMetadata {
  static late MetadataEntity instance;
  static Future<void> init() async {
    instance = await DB.loadMetadata();
    EventHub.on<HubAppInactiveEvent>((event) async {
      await DB.updateMetadata(instance);
      debugPrint('saved metadata to db: $instance');
    });
  }
}
