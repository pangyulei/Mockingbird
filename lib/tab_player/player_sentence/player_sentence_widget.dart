
import 'package:flutter/material.dart';
import '../../models/subtitle_sentence.dart';

class PlayerSentenceWidget extends StatelessWidget {
  final SubtitleSentence sentence;
  final bool isSelected;
  final VoidCallback? onTap;

  const PlayerSentenceWidget({
    required this.sentence,
    this.isSelected = false,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 60),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: isSelected 
                  ? colorScheme.primary 
                  : colorScheme.surfaceVariant.withOpacity(0.5),
              borderRadius: BorderRadius.circular(8),
              border: isSelected 
                  ? Border.all(color: colorScheme.primary, width: 2)
                  : null,
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sentence.text,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: isSelected ? colorScheme.onPrimary : colorScheme.onSurfaceVariant,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${_formatDuration(sentence.start)} - ${_formatDuration(sentence.end)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isSelected ? colorScheme.onPrimary.withOpacity(0.8) : colorScheme.outline,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    final milliseconds = (d.inMilliseconds.remainder(1000) ~/ 100).toString();
    return '$minutes:$seconds.$milliseconds';
  }
}
