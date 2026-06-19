class PlayerNavRoute {
  static const String player = 'player';
  static String urlStrForPlayer({int? mediaId}) => mediaId == null ? '/$player' : '/$player/$mediaId';
}
