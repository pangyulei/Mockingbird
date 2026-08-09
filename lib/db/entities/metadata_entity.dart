import 'package:objectbox/objectbox.dart';

@Entity()
class MetadataEntity {
  @Id()
  int id;
  final String? playingMediaId;
  final String? playingSubtitleName;
  final int databaseVersion;
  final bool permissionRequested;

  MetadataEntity({
    required this.id,
    required this.playingMediaId,
    required this.playingSubtitleName,
    required this.databaseVersion,
    required this.permissionRequested,
  });

  MetadataEntity.empty()
    : this(
        id: 0,
        playingMediaId: null,
        playingSubtitleName: null,
        databaseVersion: 0,
        permissionRequested: false,
      );

  MetadataEntity copyWith({
    String? Function()? playingMediaId,
    String? Function()? playingSubtitleName,
    int? databaseVersion,
    bool? permissionRequested,
  }) {
    return MetadataEntity(
      id: id,
      playingMediaId: playingMediaId == null
          ? this.playingMediaId
          : playingMediaId(),
      playingSubtitleName: playingSubtitleName == null
          ? this.playingSubtitleName
          : playingSubtitleName(),
      databaseVersion: databaseVersion ?? this.databaseVersion,
      permissionRequested: permissionRequested ?? this.permissionRequested,
    );
  }

  MetadataEntity incDatabaseVersion() {
    return copyWith(databaseVersion: databaseVersion + 1);
  }
}
