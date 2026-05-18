import 'package:objectbox/objectbox.dart';

@Entity()
class Track {
  @Id()
  int id;

  final String pathStr; // Full path to the media file
  final String name;
  final String? subtitlePathStr; // Full path to subtitle file if exists
  final int rawType; // Stored as int: 0 = audio, 1 = video
  //duration TODO if can parse while select, then save it dont compute each time.

  // Getter for MediaType enum
  TrackType get type =>
      TrackType.values.where((t) => t.raw == rawType).first;

  Track({
    required this.pathStr,
    required this.name,
    required this.rawType,
    this.id = 0,
    this.subtitlePathStr,
  });

  Track copyWith({
    int? id,
    String? pathStr,
    String? name,
    String? subtitlePathStr,
    int? rawType,
  }) {
    return Track(
      id: id ?? this.id,
      pathStr: pathStr ?? this.pathStr,
      name: name ?? this.name,
      subtitlePathStr: subtitlePathStr ?? this.subtitlePathStr,
      rawType: rawType ?? this.rawType,
    );
  }
}

enum TrackType {
  audio(0),
  video(1);

  final int raw;
  const TrackType(this.raw);
}
