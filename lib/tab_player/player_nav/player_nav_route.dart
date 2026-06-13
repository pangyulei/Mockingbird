class PlayerNavRoute {
  static const String player = 'player';
  static String urlStrForPlayer({int? trackId}) => trackId == null ? '/$player' : '/$player/$trackId';
}
