import 'package:flutter/material.dart';
import 'package:mockingbird/tab_player/player/sentence_card/sentence_card_state.dart';

abstract interface class SentenceCardUIOutputITF {
  void sentenceCard_onTap(int index);
}

class SentenceCardUI extends StatelessWidget {
  final SentenceCardState _state;
  final SentenceCardUIOutputITF _logic;

  const SentenceCardUI(this._state, this._logic, {super.key});

  @override
  Widget build(BuildContext ctx) {
    final colorScheme = Theme.of(ctx).colorScheme;

    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 60),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: InkWell(
          onTap: () => _logic.sentenceCard_onTap(_state.index),
          borderRadius: BorderRadius.circular(8),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: _state.isFocused
                  ? colorScheme.primary
                  : colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(8),
              border: _state.isFocused
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
                    style: Theme.of(ctx).textTheme.titleMedium?.copyWith(
                      color: _state.isFocused
                          ? colorScheme.onPrimary
                          : colorScheme.onSurfaceVariant,
                      fontWeight: _state.isFocused
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _state.period,
                    style: Theme.of(ctx).textTheme.bodySmall?.copyWith(
                      color: _state.isFocused
                          ? colorScheme.onPrimary.withValues(alpha: 0.8)
                          : colorScheme.outline,
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
