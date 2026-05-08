import 'package:objectbox/objectbox.dart';

@Entity()
class Playlist {
  @Id()
  int id;

  String name;
  String? cover;
  Playlist(this.name, {this.id = 0, this.cover});

  Playlist copyWith({
    int? id,
    String? name,
    String? cover,
  }) {
    return Playlist(
      name ?? this.name,
      id: id ?? this.id,
      cover: cover ?? this.cover,
    );
  }
}
