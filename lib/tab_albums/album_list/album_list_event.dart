sealed class AlbumListEvent {
  const AlbumListEvent();
}

class AlbumListLoadingEvent extends AlbumListEvent {
  const AlbumListLoadingEvent();
}

class AlbumListRequestPermissionEvent extends AlbumListEvent {
  const AlbumListRequestPermissionEvent();
}
