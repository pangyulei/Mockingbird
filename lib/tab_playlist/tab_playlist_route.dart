class TabPlaylistRoute {
  static const String playlists = 'playlists';
  static String urlStringForPlaylists() => '/$playlists';
  static String urlStringForPlaylist(int id) => '/$playlists/$id';
}
