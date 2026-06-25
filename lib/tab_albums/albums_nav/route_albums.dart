class RouteAlbums {
  static const String kAlbums = 'albums';
  static String get albums => '/$kAlbums';
  static String albumDetail(int id) => '/$kAlbums/$id';
}
