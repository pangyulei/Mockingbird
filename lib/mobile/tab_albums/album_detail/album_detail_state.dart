import 'package:photo_manager/photo_manager.dart';

sealed class AlbumDetailState {
  const AlbumDetailState();
}

class AlbumDetailInitState extends AlbumDetailState {
  const AlbumDetailInitState();
}

class AlbumDetailNotFoundState extends AlbumDetailState {
  const AlbumDetailNotFoundState();
}

class AlbumDetailEmptyState extends AlbumDetailState {
  final String name;
  const AlbumDetailEmptyState(this.name);

  AlbumDetailEmptyState copyWith({String? name}) {
    return AlbumDetailEmptyState(name ?? this.name);
  }
}

class AlbumDetailDataState extends AlbumDetailState {
  final String name;
  final List<AssetEntity> mediaList;

  const AlbumDetailDataState({required this.name, required this.mediaList});
  AlbumDetailDataState copyWith({
    String? name,
    List<AssetEntity>? mediaIdList,
  }) {
    return AlbumDetailDataState(
      name: name ?? this.name,
      mediaList: mediaIdList ?? mediaList,
    );
  }
}
