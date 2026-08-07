import 'package:objectbox/objectbox.dart';

@Entity()
class PreferenceEntity {
  @Id()
  int id;
  final String? playingId;
  final bool loop;
  final int dbVersion;
  final bool permissionRequested;

  PreferenceEntity({
    required this.id,
    required this.playingId,
    required this.loop,
    required this.dbVersion,
    required this.permissionRequested,
  });

  PreferenceEntity.empty()
    : this(id: 0, playingId: null, loop: false, dbVersion: 0, permissionRequested: false);

  PreferenceEntity copyWith({
    String? Function()? playingId,
    bool? loop,
    int? dbVersion,
    bool? permissionRequested,
  }) {
    return PreferenceEntity(
      id: id,
      playingId: playingId == null ? this.playingId : playingId(),
      loop: loop ?? this.loop,
      dbVersion: dbVersion ?? this.dbVersion,
      permissionRequested: permissionRequested ?? this.permissionRequested,
    );
  }

  PreferenceEntity incDBVersion() {
    return copyWith(dbVersion: dbVersion + 1);
  }
}
