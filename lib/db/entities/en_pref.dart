import 'package:objectbox/objectbox.dart';

@Entity()
class EnPref {
  @Id()
  int id;
  final int? playingId;
  final bool loop;
  final int dbVersion;

  EnPref({
    required this.id,
    required this.playingId,
    required this.loop,
    required this.dbVersion,
  });

  EnPref.empty() : this(id: 0, playingId: null, loop: false, dbVersion: 0);

  EnPref copyWith({int? Function()? playingId, bool? loop, int? dbVersion}) {
    return EnPref(
      id: id,
      playingId: playingId == null ? this.playingId : playingId(),
      loop: loop ?? this.loop,
      dbVersion: dbVersion ?? this.dbVersion,
    );
  }

  EnPref incDBVersion() {
    return copyWith(dbVersion: dbVersion + 1);
  }
}
