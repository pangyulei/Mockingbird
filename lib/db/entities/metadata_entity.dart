import 'package:objectbox/objectbox.dart';

@Entity()
class MetadataEntity {
  @Id()
  int id;
  final String? playingId;
  final int databaseVersion;
  final bool permissionRequested;

  MetadataEntity({
    required this.id,
    required this.playingId,
    required this.databaseVersion,
    required this.permissionRequested,
  });

  MetadataEntity.empty()
      : this(id: 0, playingId: null, databaseVersion: 0, permissionRequested: false);

  MetadataEntity copyWith({
    String? Function()? playingId,
    int? databaseVersion,
    bool? permissionRequested,
  }) {
    return MetadataEntity(
      id: id,
      playingId: playingId == null ? this.playingId : playingId(),
      databaseVersion: databaseVersion ?? this.databaseVersion,
      permissionRequested: permissionRequested ?? this.permissionRequested,
    );
  }

  MetadataEntity incDatabaseVersion() {
    return copyWith(databaseVersion: databaseVersion + 1);
  }
}
