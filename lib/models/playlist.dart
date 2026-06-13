import 'package:objectbox/objectbox.dart';
import 'track.dart';

@Entity()
class Playlist {
  @Id()
  int id;

  final String name;
  final String? coverPathStr;
  
  @Backlink('playlist')
  final tracks = ToMany<Track>();

  @Index()
  final int sortOrder;

  Playlist({
    required this.name,
    required this.sortOrder,
    this.id = 0,
    this.coverPathStr,
  });

  Playlist copyWith({
    int? id,
    String? name,
    String? coverPathStr,
    int? sortOrder,
    Iterable<Track>? tracks,
  }) {
    final p = Playlist(
      id: id ?? this.id,
      name: name ?? this.name,
      sortOrder: sortOrder ?? this.sortOrder,
      coverPathStr: coverPathStr ?? this.coverPathStr,
    );
    if (tracks != null) {
      p.tracks.addAll(tracks);
    } else {
      p.tracks.addAll(this.tracks);
    }
    return p;
  }
}
