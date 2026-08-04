import 'package:mockingbird/db/entities/en_media.dart';
import 'package:mockingbird/tab_assets/asset_card/asset_card_state.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'asset_card_provider.g.dart';

@riverpod
class AssetCard extends _$AssetCard {
  @override
  Future<AssetCardState?> build(String id) async {
    // For now, we assume these are system assets because they come from folder browsing
    final asset = await AssetEntity.fromId(id);
    if (asset == null) return null;

    return AssetCardState(
      name: asset.title ?? 'Unknown',
      type: asset.type == AssetType.video ? MediaType.video : MediaType.audio,
      playing: false,
    );
  }


  Future<void> deleteMedia() async {
    // Cannot delete system media from here
  }

  Future<void> play() async {
    // TODO: Implement "Play System Asset" (maybe auto-import or temporary play)
  }
}
