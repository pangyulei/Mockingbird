import 'package:objectbox/objectbox.dart';

import 'en_media.dart';

@Entity()
class EnAlbum {
  @Id()
  int id;

  // final int versionId;
  final String name;
  final String? cover;

  @Backlink('albumList')
  final mediaList = ToMany<EnMedia>();

  @Index()
  final int sortOrder;

  EnAlbum({required this.name, required this.sortOrder, required this.id, required this.cover});

  EnAlbum copyWith({
    String? name,
    String? Function()? coverFunc,
    int? sortOrder,
    List<EnMedia>? mediaList,
  }) {
    final album = EnAlbum(
      id: id,
      name: name ?? this.name,
      sortOrder: sortOrder ?? this.sortOrder,
      cover: coverFunc == null ? cover : coverFunc(),
    );
    album.mediaList.addAll(mediaList ?? this.mediaList);
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
