import 'package:equatable/equatable.dart';
import 'package:objectbox/objectbox.dart';

import 'en_media.dart';

@Entity()
class EnAlbum extends Equatable {
  @Id()
  int id;

  final String name;
  final String? cover;
  final int versionId;

  @Backlink('albums')
  final medias = ToMany<EnMedia>();

  @Index()
  final int sortOrder;

  EnAlbum({
    required this.name,
    required this.sortOrder,
    required this.id,
    required this.cover,
    required this.versionId,
  });

  EnAlbum copyWith({
    int? id,
    int? versionId,
    String? name,
    String? Function()? cover,
    int? sortOrder,
    Iterable<EnMedia>? medias,
  }) {
    final p = EnAlbum(
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
