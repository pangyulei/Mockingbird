import 'package:objectbox/objectbox.dart';
import 'media.dart';

@Entity()
class Album {
  @Id()
  int id;

  final String name;
  final String? coverPathStr;
  
  @Backlink('albums')
  final medias = ToMany<Media>();

  @Index()
  final int sortOrder;

  Album({
    required this.name,
    required this.sortOrder,
    this.id = 0,
    this.coverPathStr,
  });

  Album copyWith({
    int? id,
    String? name,
    String? coverPathStr,
    int? sortOrder,
    Iterable<Media>? medias,
  }) {
    final p = Album(
      id: id ?? this.id,
      name: name ?? this.name,
      sortOrder: sortOrder ?? this.sortOrder,
      coverPathStr: coverPathStr ?? this.coverPathStr,
    );
    if (medias != null) {
      p.medias.addAll(medias);
    } else {
      p.medias.addAll(this.medias);
    }
    return p;
  }
}
