import 'package:objectbox/objectbox.dart';

@Entity()
class Track {
  @Id()
  int id;

  final String filePath; // Full path to the media file
  final String fileName;
  final String? subtitlePath; // Full path to subtitle file if exists
  final int rawMediaType; // Stored as int: 0 = audio, 1 = video
  //duration TODO if can parse while select, then save it dont compute each time.
  @Index()
  final int sortOrder; // For ordering within playlist

  // Getter for MediaType enum
  MediaType get mediaType =>
      MediaType.values.where((m) => m.raw == rawMediaType).first;

  Track({
    required this.id,
    required this.filePath,
    required this.fileName,
    required this.rawMediaType,
    required this.sortOrder,
    this.subtitlePath,
  });

  Track copyWith({
    int? id,
    String? filePath,
    String? fileName,
    String? subtitlePath,
    int? rawMediaType,
    int? sortOrder,
  }) {
    return Track(
      id: id ?? this.id,
      filePath: filePath ?? this.filePath,
      fileName: fileName ?? this.fileName,
      subtitlePath: subtitlePath ?? this.subtitlePath,
      sortOrder: sortOrder ?? this.sortOrder,
      rawMediaType: rawMediaType ?? this.rawMediaType,
    );
  }
}

enum MediaType {
  audio(0),
  video(1);

  final int raw;
  const MediaType(this.raw);
}
