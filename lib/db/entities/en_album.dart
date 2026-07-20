import 'package:objectbox/objectbox.dart';

import 'en_media.dart';

@Entity()
class EnAlbum {
  @Id()
  int id;

  // final int versionId;
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
    // required this.versionId,
  });

  EnAlbum copyWith({
    String? name,
    String? Function()? coverFunc,
    int? sortOrder,
    List<EnMedia>? medias,
  }) {
    final album = EnAlbum(
      id: id,
      name: name ?? this.name,
      sortOrder: sortOrder ?? this.sortOrder,
      cover: coverFunc == null ? cover : coverFunc(),
    );
    album.medias.addAll(medias ?? this.medias);
    return album;
  }

  // EnAlbum incVersion() {
  //   return copyWith(versionId: versionId + 1);
  // }

  // @override
  // List<Object?> get props => [id, versionId];

  @override
  String toString() {
    return 'EnAlbum(id: $id, name: $name, cover: $cover, sortOrder: $sortOrder)';
  }
}
