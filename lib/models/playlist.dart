import 'package:objectbox/objectbox.dart';
import 'track.dart';

@Entity()
class Playlist {
  @Id()
  int id;

  final String name;
  final String? coverPathStr;
  
  // ObjectBox managed relationship
  final tracks = ToMany<Track>();

  @Index()
  final int sortOrder;

  Playlist({
    required this.name,
    required this.sortOrder,
    Iterable<Track> tracks = const [],
    this.id = 0,
    this.coverPathStr,
  }) {
    this.tracks.addAll(tracks);
  }

  Playlist copyWith({
    int? id,
    String? name,
    String? coverPathStr,
    int? sortOrder,
    Iterable<Track>? tracks,
  }) {
    return Playlist(
      id: id ?? this.id,
      name: name ?? this.name,
      sortOrder: sortOrder ?? this.sortOrder,
      coverPathStr: coverPathStr ?? this.coverPathStr,
      tracks: (tracks ?? this.tracks).map((t) => t.copyWith()),
    );
  }
}
