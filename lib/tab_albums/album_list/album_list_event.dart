sealed class AlbumListEvent {
  const AlbumListEvent();
}

class AlbumListInitEvent extends AlbumListEvent {
  const AlbumListInitEvent();
}

class AlbumListRequestPermissionEvent extends AlbumListEvent {
  const AlbumListRequestPermissionEvent();
}
