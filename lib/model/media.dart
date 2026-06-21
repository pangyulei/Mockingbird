
import 'album.dart';
import 'subtitle.dart';
import 'package:objectbox/objectbox.dart';
import 'package:path/path.dart' as p;

@Entity()
class Media {
  @Id()
  int id;

  final albums = ToMany<Album>();
  final String path; // Full path to the media file
  final String name;
  final subtitle = ToOne<Subtitle>();

  //objectbox will use this default constructor
  Media({
    required this.path,
    required this.name,
    this.id = 0,
  });

  MediaType get type => MediaType.fromExtension(p.extension(path));

  Media copyWith({
    int? id,
    String? path,
    String? name,
    Subtitle? subtitle,
    List<Album>? albums,
  }) {
    final media = Media(
      id: id ?? this.id,
      path: path ?? this.path,
      name: name ?? this.name,
    );
    media.subtitle.target = subtitle ?? this.subtitle.target;
    media.albums.addAll(albums ?? this.albums);
    return media;
  }
}

enum MediaType {
  audio(0),
  video(1);

  final int raw;
  const MediaType(this.raw);

  static MediaType fromExtension(String ext) {
    if (ext.startsWith('.')) ext = ext.substring(1);
    ext = ext.toLowerCase();
    if (videoExtensions.contains(ext)) return MediaType.video;
    if (audioExtensions.contains(ext)) return MediaType.audio;
    throw ArgumentError('Unsupported file extension: $ext');
  }
}

const audioExtensions = {'mp3', 'm4a', 'aac', 'wav', 'ogg', 'oga', 'flac', 'amr'};
const videoExtensions = {'mp4', 'm4v', 'mkv', 'webm', '3gp', 'ts', 'flv'};
const subtitleExtensions = {'srt', 'vtt'};
