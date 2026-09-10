sealed class AlbumListEvent {
  const AlbumListEvent();
}

class AlbumListInitEvent extends AlbumListEvent {
  const AlbumListInitEvent();
}

class AlbumListResumeEvent extends AlbumListEvent {
  const AlbumListResumeEvent();
}

class AlbumListRequestPermissionEvent extends AlbumListEvent {
  const AlbumListRequestPermissionEvent();
}
