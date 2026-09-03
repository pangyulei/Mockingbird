import 'dart:nativewrappers/_internal/vm/lib/ffi_allocation_patch.dart';

import 'package:collection/collection.dart';
import 'package:mockingbird/db/entities/media_progress_entity.dart';
import 'package:mockingbird/tool/extensions.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class MetadataEntity {
  @Id()
  int id;

  final mediaProgressList = ToMany<MediaProgressEntity>();
  final int databaseVersion;
  final String? playingMediaId;
  final bool permissionRequested;

  MetadataEntity({
    this.id = 0,
    this.playingMediaId,
    this.databaseVersion = 0,
    this.permissionRequested = false,
  });

  MetadataEntity copyWith({
    String? Function()? playingMediaId,
    int? databaseVersion,
    bool? permissionRequested,
    List<MediaProgressEntity>? mediaProgressList,
  }) {
    final metadata = MetadataEntity(
      id: id,
      databaseVersion: databaseVersion ?? this.databaseVersion,
      permissionRequested: permissionRequested ?? this.permissionRequested,
      playingMediaId: playingMediaId?.call() ?? this.playingMediaId,
    );
    metadata.mediaProgressList.addAll(
      mediaProgressList ?? this.mediaProgressList,
    );
    return metadata;
  }

  MetadataEntity incDatabaseVersion() {
    return copyWith(databaseVersion: databaseVersion + 1);
  }

  MediaProgressEntity? mediaProgressById(String? mediaId) =>
      mediaProgressList.firstWhereOrNull((mp) => mp.mediaId == mediaId);
  void updateMediaProgress(MediaProgressEntity? progress) {
    if (progress == null) return;
    final i = mediaProgressList.firstIndexWhereOrNull(
      (mp) => mp.mediaId == progress.mediaId,
    );
    if (i == null) {
      mediaProgressList.add(progress);
    } else {
      mediaProgressList[i] = progress;
    }
  }

  @override
  String toString() {
    final progressString = mediaProgressList
        .map((mp) => mp.toString())
        .join(',');
    return 'MetadataEntity(id: $id, databaseVersion: $databaseVersion, playingMediaId: $playingMediaId, permissionRequested: $permissionRequested, mediaProgressList: [$progressString])';
  }
}
