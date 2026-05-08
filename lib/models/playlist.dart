import 'package:objectbox/objectbox.dart';

@Entity()
class Playlist {
  @Id()
  int id;

  String name;
  Playlist(this.name, {this.id = 0});
}
