import 'dart:io';

import 'package:objectbox/objectbox.dart';
import 'package:path/path.dart' as p;

@Entity()
class Track {
  @Id()
  int id;

  final String pathStr; // Full path to the media file
  final String name;
  final String? subPathStr; // Full path to subtitle file if exists
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
    this.subPathStr,
  });

  Track copyWith({
    int? id,
    String? pathStr,
    String? name,
    String? subPathStr,
    int? rawType,
  }) {
    return Track(
      id: id ?? this.id,
      pathStr: pathStr ?? this.pathStr,
      name: name ?? this.name,
      subPathStr: subPathStr ?? this.subPathStr,
      rawType: rawType ?? this.rawType,
    );
  }
}

enum TrackType {
  audio(0),
  video(1);

  final int raw;
  const TrackType(this.raw);

  static TrackType fromFile(File file) {
    return fromExtension(p.extension(file.path));
  }

  static TrackType fromExtension(String ext) {
    if (ext.isEmpty) throw ArgumentError('Extension cannot be empty');
    if (ext.startsWith('.')) ext = ext.substring(1);
    ext = ext.toLowerCase();
    if (videoExtensions.contains(ext)) return TrackType.video;
    if (audioExtensions.contains(ext)) return TrackType.audio;
    throw ArgumentError('Unsupported file extension: $ext');
  }
}

const audioExtensions = {'mp3', 'wav', 'aac', 'm4a', 'flac', 'ogg', 'wma'};
const videoExtensions = {'mp4', 'avi', 'mkv', 'mov', 'wmv', 'flv', 'webm'};
const subtitleExtensions = {'srt', 'vtt', 'sub', 'ass'};
