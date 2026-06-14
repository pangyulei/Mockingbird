import 'dart:io';
import '../../models/subtitle_sentence.dart';

class SubtitleParser {
  static Future<List<SubtitleSentence>> parse(String path) async {
    final file = File(path);
    if (!await file.exists()) return [];

    final content = await file.readAsString();
    if (path.toLowerCase().endsWith('.srt')) {
      return _parseSrt(content);
    } else if (path.toLowerCase().endsWith('.vtt')) {
      return _parseVtt(content);
    }
    return [];
  }

  static List<SubtitleSentence> _parseSrt(String content) {
    final sentences = <SubtitleSentence>[];
    // Split by double newline (supporting both \n and \r\n)
    final blocks = content.trim().split(RegExp(r'(\r?\n){2,}'));

    for (var block in blocks) {
      final lines = block.trim().split(RegExp(r'\r?\n'));
      if (lines.length < 2) continue;

      // SRT blocks usually have an index line, then time line, then text lines
      // But sometimes the index line is missing in malformed files
      String timeLine;
      int textStartIndex;

      if (lines[0].contains(' --> ')) {
        timeLine = lines[0];
        textStartIndex = 1;
      } else if (lines.length >= 2 && lines[1].contains(' --> ')) {
        timeLine = lines[1];
        textStartIndex = 2;
      } else {
        continue;
      }

      final times = timeLine.split(' --> ');
      if (times.length != 2) continue;

      try {
        final start = _parseSrtTime(times[0].trim());
        final end = _parseSrtTime(times[1].trim());
        final text = lines.sublist(textStartIndex).join('\n').trim();

        if (text.isNotEmpty) {
          sentences.add(SubtitleSentence(start: start, end: end, text: text));
        }
      } catch (e) {
        // Skip malformed blocks
        print('Error parsing SRT block: $e');
      }
    }

    return sentences;
  }

  static Duration _parseSrtTime(String timeStr) {
    // 00:00:20,000
    final parts = timeStr.split(':');
    final hours = int.parse(parts[0]);
    final minutes = int.parse(parts[1]);
    final secondsParts = parts[2].replaceFirst(',', '.').split('.');
    final seconds = int.parse(secondsParts[0]);
    final milliseconds = int.parse(secondsParts[1].padRight(3, '0').substring(0, 3));

    return Duration(
      hours: hours,
      minutes: minutes,
      seconds: seconds,
      milliseconds: milliseconds,
    );
  }

  static List<SubtitleSentence> _parseVtt(String content) {
    final sentences = <SubtitleSentence>[];
    final blocks = content.trim().split(RegExp(r'(\r?\n){2,}'));

    for (var block in blocks) {
      if (block.trim().startsWith('WEBVTT')) continue;
      
      final lines = block.trim().split(RegExp(r'\r?\n'));
      if (lines.isEmpty) continue;

      String timeLine = "";
      int textStartLine = 0;

      if (lines[0].contains(' --> ')) {
        timeLine = lines[0];
        textStartLine = 1;
      } else if (lines.length > 1 && lines[1].contains(' --> ')) {
        timeLine = lines[1];
        textStartLine = 2;
      } else {
        continue;
      }

      final times = timeLine.split(' --> ');
      if (times.length != 2) continue;

      try {
        final start = _parseVttTime(times[0].trim());
        final end = _parseVttTime(times[1].trim());
        final text = lines.sublist(textStartLine).join('\n').trim();

        if (text.isNotEmpty) {
          sentences.add(SubtitleSentence(start: start, end: end, text: text));
        }
      } catch (e) {
        print('Error parsing VTT block: $e');
      }
    }
    return sentences;
  }

  static Duration _parseVttTime(String timeStr) {
    // 00:00:20.000 or 00:20.000
    final parts = timeStr.split(':');
    int hours = 0;
    int minutes = 0;
    String lastPart = "";

    if (parts.length == 3) {
      hours = int.parse(parts[0]);
      minutes = int.parse(parts[1]);
      lastPart = parts[2];
    } else if (parts.length == 2) {
      minutes = int.parse(parts[0]);
      lastPart = parts[1];
    } else {
      throw FormatException('Invalid VTT time format');
    }

    final secondsParts = lastPart.split('.');
    final seconds = int.parse(secondsParts[0]);
    final milliseconds = int.parse(secondsParts.length > 1 
        ? secondsParts[1].padRight(3, '0').substring(0, 3) 
        : '0');

    return Duration(
      hours: hours,
      minutes: minutes,
      seconds: seconds,
      milliseconds: milliseconds,
    );
  }
}
