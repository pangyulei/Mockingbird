import 'package:equatable/equatable.dart';
import 'package:objectbox/objectbox.dart';

import 'db_media.dart';

@Entity()
class DBAlbum extends Equatable {
  @Id()
  int id;

  final String name;
  final String? cover;
  final int versionId;

  @Backlink('albums')
  final medias = ToMany<DBMedia>();

  @Index()
  final int sortOrder;

  DBAlbum({
    required this.name,
    required this.sortOrder,
    required this.id,
    required this.cover,
    required this.versionId,
  });

  DBAlbum copyWith({
    int? id,
    int? versionId,
    String? name,
    String? Function()? cover,
    int? sortOrder,
    Iterable<DBMedia>? medias,
  }) {
    final p = DBAlbum(
      versionId: versionId ?? this.versionId,
      id: id ?? this.id,
      name: name ?? this.name,
      sortOrder: sortOrder ?? this.sortOrder,
      cover: cover != null ? cover() : this.cover,
    );
    if (medias != null) {
      p.medias.addAll(medias);
    } else {
      p.medias.addAll(this.medias);
    }
    return p;
  }

  @override
  List<Object?> get props => [id, versionId];
}
