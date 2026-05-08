import 'package:objectbox/objectbox.dart';

@Entity()
class Playlist {
  @Id()
  int id;

  String name;
  String? cover;
  int sortOrder;
  
  Playlist(this.name, {this.id = 0, this.cover, this.sortOrder = 0});

  Playlist copyWith({
    int? id,
    String? name,
    String? cover,
    int? sortOrder,
  }) {
    return Playlist(
      name ?? this.name,
      id: id ?? this.id,
      cover: cover ?? this.cover,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }
}
