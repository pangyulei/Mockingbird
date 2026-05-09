import 'package:objectbox/objectbox.dart';

@Entity()
class Playlist {
  @Id()
  int id;

  final String name;
  final String? cover;
  final int sortOrder;

  Playlist(this.name, this.sortOrder, {this.id = 0, this.cover});

  Playlist copyWith({int? id, String? name, String? cover, int? sortOrder}) {
    return Playlist(
      name ?? this.name,
      sortOrder ?? this.sortOrder,
      id: id ?? this.id,
      cover: cover ?? this.cover,
    );
  }
}
