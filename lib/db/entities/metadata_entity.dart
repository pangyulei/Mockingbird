import 'package:objectbox/objectbox.dart';

@Entity()
class MetadataEntity {
  @Id()
  int id;
  final String? playingMediaId;
  final String? playingSubtitleName;
  final int playingPositionMs;
  final int databaseVersion;
  final bool permissionRequested;

  MetadataEntity({
    required this.id,
    required this.playingMediaId,
    required this.playingSubtitleName,
    required this.playingPositionMs,
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
        playingPositionMs: 0,
      );

  MetadataEntity copyWith({
    String? Function()? playingMediaId,
    String? Function()? playingSubtitleName,
    int? playingPositionMs,
    int? databaseVersion,
    bool? permissionRequested,
  }) {
    return MetadataEntity(
      id: id,
      playingPositionMs: playingPositionMs ?? this.playingPositionMs,
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

  Duration get playingPosition => Duration(milliseconds: playingPositionMs);
}
