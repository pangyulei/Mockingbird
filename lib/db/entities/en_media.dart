import 'package:objectbox/objectbox.dart';
import 'package:path/path.dart' as p;

import 'en_album.dart';
import 'en_subtitle.dart';

@Entity()
class EnMedia {
  @Id()
  int id;

  final albums = ToMany<EnAlbum>();
  final String path; // Full path to the media file
  final String name;
  @Backlink('media')
  final subtitles = ToMany<EnSubtitle>();

  //objectbox will use this default constructor
  EnMedia({required this.path, required this.name, required this.id});

  MediaType get type => MediaType.fromExtension(p.extension(path));

  EnMedia copyWith({
    String? path,
    String? name,
    List<EnSubtitle>? subtitles,
    List<EnAlbum>? albums,
  }) {
    final media = EnMedia(
      id: id,
      path: path ?? this.path,
      name: name ?? this.name,
    );
    media.subtitles.addAll(subtitles ?? this.subtitles);
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
    if (kVideoExtensions.contains(ext)) return MediaType.video;
    if (kAudioExtensions.contains(ext)) return MediaType.audio;
    throw ArgumentError('Unsupported file extension: $ext');
  }
}

const kAudioExtensions = {
  'mp3',
  'm4a',
  'aac',
  'wav',
  'ogg',
  'oga',
  'flac',
  'amr',
};
const kVideoExtensions = {'mp4', 'm4v', 'mkv', 'webm', '3gp', 'ts', 'flv'};
const kSubtitleExtensions = {'srt', 'vtt'};
