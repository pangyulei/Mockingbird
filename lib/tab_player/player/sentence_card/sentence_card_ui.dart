import 'package:flutter/material.dart';
import 'package:mockingbird/tab_player/player/sentence_card/sentence_card_state.dart';

abstract interface class SentenceCardUIOutputITF {
  void sentenceCard_onTap(int index);
}

class SentenceCardUI extends StatelessWidget {
  final SentenceCardState _state;
  final SentenceCardUIOutputITF _logic;
  final int _index;
  const SentenceCardUI(this._index, this._state, this._logic, {super.key});
  
  @override
  Widget build(BuildContext ctx) {
    final theme = Theme.of(ctx);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        onTap: () => _logic.sentenceCard_onTap(_index),
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: _state.isFocused
                ? colorScheme.primaryContainer.withValues(alpha: 0.8)
                : colorScheme.surface,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(16),
              topRight: const Radius.circular(16),
              bottomRight: const Radius.circular(16),
              bottomLeft: Radius.circular(_state.isFocused ? 4 : 16),
            ),
            boxShadow: _state.isFocused
                ? [
                    BoxShadow(
                      color: colorScheme.primary.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
            border: Border.all(
              color: _state.isFocused
                  ? colorScheme.primary.withValues(alpha: 0.3)
                  : Colors.white.withValues(alpha: 0.05),
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _state.text,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: _state.isFocused
                        ? colorScheme.onPrimaryContainer
                        : colorScheme.onSurface,
                    fontSize: 16,
                    height: 1.4,
                    fontWeight: _state.isFocused ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      _state.period,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: _state.isFocused
                            ? colorScheme.primary
                            : colorScheme.outline,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
