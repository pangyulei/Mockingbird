class TabPlaylistRoute {
  static const String playlists = 'playlists';
  static String urlStringForPlaylists() => '/$playlists';
  static String urlStringForPlaylist(String name) => '/$playlists/$name';
}
