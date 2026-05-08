import 'package:objectbox/objectbox.dart';

@Entity()
class Playlist {
  @Id()
  int id;

  String name;
  String? cover;
  Playlist(this.name, {this.id = 0, this.cover});
}
