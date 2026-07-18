import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:mockingbird/tab_player/player/sentence_card/sentence_card_state.dart';

abstract interface class SentenceCardNotifierITF {
  // void sentenceCard_onTap(int index);
}

class SentenceCardUI extends ConsumerWidget {
  final ProviderListenable<SentenceCardState> _provider;
  final SentenceCardNotifierITF _notifier;
  const SentenceCardUI(this._provider, this._notifier, {super.key});

  void _onTap() {}

  @override
  Widget build(BuildContext ctx, WidgetRef ref) {
    final theme = Theme.of(ctx);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        onTap: _onTap,
        borderRadius: BorderRadius.circular(16),
        child: Consumer(
          builder: (ctx, ref, _) {
            final isPlaying = ref.watch(_provider.select((st) => st.isPlaying));
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              decoration: BoxDecoration(
                color: isPlaying
                    ? colorScheme.primaryContainer.withValues(alpha: 0.8)
                    : colorScheme.surface,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isPlaying ? 4 : 16),
                ),
                boxShadow: isPlaying
                    ? [
                        BoxShadow(
                          color: colorScheme.primary.withValues(alpha: 0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
                border: Border.all(
                  color: isPlaying
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
                    Consumer(
                      builder: (context, ref, child) {
                        final text = ref.watch(
                          _provider.select((st) => st.text),
                        );
                        return Text(
                          text,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: isPlaying
                                ? colorScheme.onPrimaryContainer
                                : colorScheme.onSurface,
                            fontSize: 16,
                            height: 1.4,
                            fontWeight: isPlaying
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Consumer(
                          builder: (context, ref, child) {
                            final period = ref.watch(
                              _provider.select((st) => st.period),
                            );
                            return Text(
                              period,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: isPlaying
                                    ? colorScheme.primary
                                    : colorScheme.outline,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
