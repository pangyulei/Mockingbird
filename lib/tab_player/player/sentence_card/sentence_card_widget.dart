
import 'package:flutter/material.dart';
import 'package:mockingbird/tab_player/player/sentence_card/sentence_card_interface_ui_events.dart';
import 'package:mockingbird/tab_player/player/sentence_card/sentence_card_state.dart';




class SentenceCardWidget extends StatelessWidget {
  final SentenceCardState _state;
  final SentenceCardInterfaceUIEvents _logic;

  const SentenceCardWidget({
    required this._state,
    required this._logic,
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
          onTap: () => _logic.sentenceCardClicked(_state.index),
          borderRadius: BorderRadius.circular(8),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: _state.isPlaying
                  ? colorScheme.primary 
                  : colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(8),
              border: _state.isPlaying
                  ? Border.all(color: colorScheme.primary, width: 2)
                  : null,
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _state.text,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: _state.isPlaying ? colorScheme.onPrimary : colorScheme.onSurfaceVariant,
                      fontWeight: _state.isPlaying ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _state.period,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: _state.isPlaying ? colorScheme.onPrimary.withOpacity(0.8) : colorScheme.outline,
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


}
