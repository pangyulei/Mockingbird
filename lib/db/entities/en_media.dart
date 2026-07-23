import 'package:objectbox/objectbox.dart';
import 'package:path/path.dart' as p;

import 'en_album.dart';
import 'en_subtitle.dart';

@Entity()
class EnMedia {
  @Id()
  int id;

  final String path; // Full path to the media file
  final String name;
  final albumList = ToMany<EnAlbum>();
  @Backlink('media')
  final subtitleList = ToMany<EnSubtitle>();

  //objectbox will use this default constructor
  EnMedia({required this.path, required this.name, required this.id});

  MediaType get type => MediaType.fromPath(path);

  EnMedia copyWith({String? name, List<EnSubtitle>? subtitleList}) {
    final media = EnMedia(id: id, path: path, name: name ?? this.name);
    media.subtitleList.addAll(subtitleList ?? this.subtitleList);
    media.albumList.addAll(albumList);
    return media;
  }

  @override
  String toString() {
    return 'EnMedia(id: $id, name: $name, path: $path, type: $type)';
  }
}

enum MediaType {
  audio(0),
  video(1);

  final int raw;

  const MediaType(this.raw);

  static MediaType fromPath(String path) {
    final String extension = path.toLowerCase().split('.').last;
    if (kVideoExtensions.contains(extension)) return MediaType.video;
    if (kAudioExtensions.contains(extension)) return MediaType.audio;
    throw ArgumentError('Unsupported file extension: $extension');
  }
}

const kAudioExtensions = {'mp3', 'm4a', 'aac', 'wav', 'ogg', 'oga', 'flac', 'amr'};
const kVideoExtensions = {'mp4', 'm4v', 'mkv', 'webm', '3gp', 'ts', 'flv'};
const kSubtitleExtensions = {'srt', 'vtt'};
