import 'package:objectbox/objectbox.dart';

import 'track.dart';

@Entity()
class Playlist {
  @Id()
  int id;

  final String name;
  final String? coverPathStr;
  //TODO rename properties guide, relate to db upgrade.
  final ToMany<Track> tracks;

  @Index()
  final int sortOrder;

  Playlist({
    required this.name,
    required this.sortOrder,
    required this.tracks,
    this.id = 0,
    this.coverPathStr,
  });

  Playlist copyWith({
    int? id,
    String? name,
    String? localCoverPathStr,
    int? sortOrder,
    Iterable<Track>? tracks,
  }) {
    return Playlist(
      id: id ?? this.id,
      name: name ?? this.name,
      sortOrder: sortOrder ?? this.sortOrder,
      coverPathStr: localCoverPathStr ?? this.coverPathStr,
      tracks: ToMany<Track>(items: (tracks ?? this.tracks).map((t) => t.copyWith()).toList()),
    );
  }
}
