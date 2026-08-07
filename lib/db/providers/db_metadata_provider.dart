import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockingbird/db/db_logic.dart';
import 'package:mockingbird/db/entities/metadata_entity.dart';

final dbMetadataProvider = AsyncNotifierProvider(DBMetadataNotifier.new);

class DBMetadataNotifier extends AsyncNotifier<MetadataEntity> {
  @override
  Future<MetadataEntity> build() async {
    return (await DBLogic().loadMetadata()) ?? MetadataEntity.empty();
  }

  Future<void> setPlayingId(String id) async {
    final pref = await future;
    if (pref.playingId != id) {
      await _updateMetadata((pref) => pref.copyWith(playingId: () => id));
    }
  }

  Future<void> setPermissionRequested() async {
    await _updateMetadata((pref) => pref.copyWith(permissionRequested: true));
  }

  Future<void> _updateMetadata(
    MetadataEntity Function(MetadataEntity metadata) getter,
  ) async {
    final metadata = await future;
    debugPrint('pref provider state got');
    final updatedMetadata = getter(metadata);
    if (updatedMetadata != metadata) {
      await DBLogic().updateMetadata(updatedMetadata);
      state = AsyncData(updatedMetadata);
    }
    debugPrint('pref provider updated');
  }
}
