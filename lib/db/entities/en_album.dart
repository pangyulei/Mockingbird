import 'package:objectbox/objectbox.dart';

import 'en_media.dart';

@Entity()
class EnAlbum {
  @Id()
  int id;

  final String name;
  final String? cover;

  @Backlink('albums')
  final medias = ToMany<EnMedia>();

  @Index()
  final int sortOrder;

  EnAlbum({
    required this.name,
    required this.sortOrder,
    required this.id,
    required this.cover,
  });

  EnAlbum copyWith({
    String? name,
    String? Function()? cover,
    int? sortOrder,
    Iterable<EnMedia>? medias,
  }) {
    final album = EnAlbum(
      id: id,
      name: name ?? this.name,
      sortOrder: sortOrder ?? this.sortOrder,
      cover: cover != null ? cover() : this.cover,
    );
    album.medias.addAll(medias ?? this.medias);
    return album;
  }
}
