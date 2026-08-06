import 'package:objectbox/objectbox.dart';

@Entity()
class PreferenceEntity {
  @Id()
  int id;
  final String? playingId;
  final bool loop;
  final int dbVersion;

  PreferenceEntity({
    required this.id,
    required this.playingId,
    required this.loop,
    required this.dbVersion,
  });

  PreferenceEntity.empty()
    : this(id: 0, playingId: null, loop: false, dbVersion: 0);

  PreferenceEntity copyWith({
    String? Function()? playingId,
    bool? loop,
    int? dbVersion,
  }) {
    return PreferenceEntity(
      id: id,
      playingId: playingId == null ? this.playingId : playingId(),
      loop: loop ?? this.loop,
      dbVersion: dbVersion ?? this.dbVersion,
    );
  }

  PreferenceEntity incDBVersion() {
    return copyWith(dbVersion: dbVersion + 1);
  }
}
