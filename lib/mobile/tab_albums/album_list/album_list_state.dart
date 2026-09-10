import 'package:photo_manager/photo_manager.dart';

sealed class AlbumListState {
  const AlbumListState();
}

class AlbumListInitState extends AlbumListState {
  const AlbumListInitState();
}

class AlbumListNotYetRequestedState extends AlbumListState {
  const AlbumListNotYetRequestedState();
}

class AlbumListPermissionDeniedState extends AlbumListState {
  const AlbumListPermissionDeniedState();
}

class AlbumListEmptyState extends AlbumListState {
  const AlbumListEmptyState();
}

class AlbumListDataState extends AlbumListState {
  final List<AssetPathEntity> albumList;
  const AlbumListDataState(this.albumList);
}
