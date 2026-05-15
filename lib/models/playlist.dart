import 'package:objectbox/objectbox.dart';

import 'track.dart';

@Entity()
class Playlist {
  @Id()
  int id;

  final String name; //TODO may add remoteCoverURLStr
  final String? cover; //TODO renmae to localCoverPathStr
  //TODO rename properties guild, relate to db upgrade.
  final tracks = ToMany<Track>();

  @Index()
  final int sortOrder;

  Playlist({
    required this.name,
    required this.sortOrder,
    Iterable<Track>? tracks,
    this.id = 0,
    this.cover,
  }) {
    if (tracks != null) {
      this.tracks.addAll(tracks.map((e) => e.copyWith()));
    }
  }

  Playlist copyWith({
    int? id,
    String? name,
    String? cover,
    int? sortOrder,
    Iterable<Track>? tracks,
  }) {
    return Playlist(
      id: id ?? this.id,
      name: name ?? this.name,
      sortOrder: sortOrder ?? this.sortOrder,
      cover: cover ?? this.cover,
      tracks: tracks ?? this.tracks,
    );
  }
}
