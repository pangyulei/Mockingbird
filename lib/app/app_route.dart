class AppRoute {
  static const String _kAlbums = 'albums';
  static String get albums => '/$_kAlbums';
  static String albumById(int id) => '/$_kAlbums/$id';

  static const String _kPlayer = 'player';
  static String get player => '/$_kPlayer';
  static String playerById(int id) => '/$_kPlayer/$id';
  
  static const String _kSettings = 'settings';
  static String get settings => '/$_kSettings';
  
}
