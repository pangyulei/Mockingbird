import 'package:equatable/equatable.dart';
import 'package:objectbox/objectbox.dart';
import 'package:path/path.dart' as p;

import 'en_album.dart';
import 'en_subtitle.dart';

@Entity()
class EnMedia extends Equatable {
  @Id()
  int id;

  final albums = ToMany<EnAlbum>();
  final String path; // Full path to the media file
  final String name;
  final int versionId;
  @Backlink('media')
  final subtitles = ToMany<EnSubtitle>();

  //objectbox will use this default constructor
  EnMedia({
    required this.path,
    required this.name,
    required this.id,
    required this.versionId,
  });

  MediaType get type => MediaType.fromExtension(p.extension(path));

  EnMedia copyWith({
    int? id,
    int? versionId,
    String? path,
    String? name,
    List<EnSubtitle>? Function()? subtitles,
    List<EnAlbum>? albums,
  }) {
    final media = EnMedia(
      id: id ?? this.id,
      versionId: versionId ?? this.versionId,
      path: path ?? this.path,
      name: name ?? this.name,
    );
    if (subtitles != null) {
      final res = subtitles();
      if (res != null) {
        media.subtitles.addAll(res);
      }
    } else {
      media.subtitles.addAll(this.subtitles);
    }
    media.albums.addAll(albums ?? this.albums);
    return media;
  }

  EnMedia incVersion() {
    return copyWith(versionId: versionId + 1);
  }

  @override
  List<Object?> get props => [id, versionId];
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
