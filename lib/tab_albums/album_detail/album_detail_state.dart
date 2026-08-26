import 'package:photo_manager/photo_manager.dart';

sealed class AlbumDetailState {
  final bool loading; //TODO use easyloading, no need to define loading flag
  const AlbumDetailState({this.loading = false});
  AlbumDetailState copyWith({bool? loading});
}

class AlbumDetailInitState extends AlbumDetailState {
  const AlbumDetailInitState() : super(loading: true);

  @override
  AlbumDetailInitState copyWith({bool? loading}) {
    return this;
  }
}

class AlbumDetailNotFoundState extends AlbumDetailState {
  const AlbumDetailNotFoundState({super.loading});

  @override
  AlbumDetailNotFoundState copyWith({bool? loading}) {
    return AlbumDetailNotFoundState(loading: loading ?? this.loading);
  }
}

class AlbumDetailEmptyState extends AlbumDetailState {
  final String name;
  const AlbumDetailEmptyState({super.loading, required this.name});
  @override
  AlbumDetailEmptyState copyWith({bool? loading, String? name}) {
    return AlbumDetailEmptyState(
      loading: loading ?? this.loading,
      name: name ?? this.name,
    );
  }
}

class AlbumDetailDataState extends AlbumDetailState {
  final String name;
  final List<AssetEntity> mediaList;

  const AlbumDetailDataState({
    super.loading,
    required this.name,
    required this.mediaList,
  });
  @override
  AlbumDetailDataState copyWith({
    bool? loading,
    String? name,
    List<AssetEntity>? mediaIdList,
  }) {
    return AlbumDetailDataState(
      loading: loading ?? this.loading,
      name: name ?? this.name,
      mediaList: mediaIdList ?? mediaList,
    );
  }
}
