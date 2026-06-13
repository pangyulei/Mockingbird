import 'dart:io';

import 'package:mockingbird/models/playlist.dart';
import 'package:objectbox/objectbox.dart';
import 'package:path/path.dart' as p;

@Entity()
class Track {
  @Id()
  int id;

  final playlist = ToOne<Playlist>();
  final String pathStr; // Full path to the media file
  final String name;
  final String? subPathStr; // Full path to subtitle file if exists
  final int rawType; // Stored as int: 0 = audio, 1 = video

  // Getter for MediaType enum
  TrackType get type =>
      TrackType.values.firstWhere((t) => t.raw == rawType);

  Track({
    required this.pathStr,
    required this.name,
    required this.rawType,
    /*
    默认objectbox不需要这个参数，就会找到playlist, 这个参数是用来自己构造Track对象的
    所以playlist可传可不传，自己构造的时候必须传，objectbox拿取的时候它底层不需要传
    */
    Playlist? playlist,
    this.id = 0,
    this.subPathStr,
  }) {
    if (playlist != null) {
      this.playlist.target = playlist;
    }
  }

  Track copyWith({
    int? id,
    String? pathStr,
    String? name,
    String? subPathStr,
    int? rawType,
    Playlist? playlist,
  }) {
    return Track(
      id: id ?? this.id,
      pathStr: pathStr ?? this.pathStr,
      name: name ?? this.name,
      subPathStr: subPathStr ?? this.subPathStr,
      rawType: rawType ?? this.rawType,
      playlist: playlist ?? this.playlist.target
    );
  }
}

enum TrackType {
  audio(0),
  video(1);

  final int raw;
  const TrackType(this.raw);

  static TrackType fromFile(File file) {
    var ext = p.extension(file.path);
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
