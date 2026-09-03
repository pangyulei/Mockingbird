import 'dart:nativewrappers/_internal/vm/lib/ffi_allocation_patch.dart';

import 'package:objectbox/objectbox.dart';

@Entity()
class MediaProgressEntity {
  @Id()
  int id;
  final String mediaId;
  final String? subtitleName;
  final int positionMs;

  MediaProgressEntity({
    this.id = 0,
    this.mediaId = '',
    this.subtitleName,
    this.positionMs = 0,
  });

  MediaProgressEntity copyWith({
    String? Function()? subtitleName,
    int? positionMs,
    String? mediaId,
  }) {
    return MediaProgressEntity(
      id: id,
      subtitleName: subtitleName?.call() ?? this.subtitleName,
      positionMs: positionMs ?? this.positionMs,
      mediaId: mediaId ?? this.mediaId,
    );
  }

  Duration get position => Duration(milliseconds: positionMs);

  @override
  String toString() {
    return 'MediaProgressEntity(id: $id, mediaId: $mediaId, subtitleName: $subtitleName, positionMs: $positionMs)';
  }
}
