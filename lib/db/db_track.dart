import 'dart:io';

import 'package:mockingbird/models/track.dart';
import 'package:mockingbird/objectbox.g.dart';
import 'package:path/path.dart' as p;

class DBTrack {
  final Box<Track> _box;
  DBTrack(Store store) : _box = store.box<Track>();

  Future<List<Track>> createManyAsync(List<Track> tracks) async {
    if (tracks.isEmpty) return [];
    
    await _box.putManyAsync(tracks);
    return tracks;
  }

  Future<List<Track>> getByPlaylistIdAsync(int playlistId) async {
    // Note: Track doesn't have playlistId field in current model
    // This would need to be implemented based on actual relationship design
    final query = _box
        .query()
        .order(Track_.sortOrder)
        .build();
    final result = await query.findAsync();
    query.close();
    return result;
  }

  /// Helper method to detect subtitle file for a given media file
  static String? findSubtitleFile(String mediaFilePath) {
    final directory = p.dirname(mediaFilePath);
    final baseName = p.basenameWithoutExtension(mediaFilePath);
    
    // Check for common subtitle extensions
    const subtitleExtensions = ['.srt', '.vtt', '.sub', '.ass'];
    
    for (final ext in subtitleExtensions) {
      final subtitlePath = p.join(directory, '$baseName$ext');
      if (File(subtitlePath).existsSync()) {
        return subtitlePath;
      }
    }
    
    return null;
  }

  /// Helper method to determine media type from file extension
  static MediaType getMediaTypeFromExtension(String filePath) {
    final extension = p.extension(filePath).toLowerCase();
    
    const audioExtensions = ['.mp3', '.wav', '.aac', '.m4a', '.flac', '.ogg', '.wma'];
    const videoExtensions = ['.mp4', '.avi', '.mkv', '.mov', '.wmv', '.flv', '.webm'];
    
    if (audioExtensions.contains(extension)) {
      return MediaType.audio;
    } else if (videoExtensions.contains(extension)) {
      return MediaType.video;
    }
    
    // Default to audio if unknown
    return MediaType.audio;
  }
}
