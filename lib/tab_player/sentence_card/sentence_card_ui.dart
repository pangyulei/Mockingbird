import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockingbird/tab_player/sentence_card/sentence_card_provider.dart';
import 'package:mockingbird/tab_player/sentence_card/sentence_card_state.dart';

class SentenceCardUI extends ConsumerWidget {
  final String _id;
  final void Function(WidgetRef ref, String id) _onTapCallback;
  const SentenceCardUI(this._id, this._onTapCallback, {super.key});

  void _onTap(WidgetRef ref) {
    _onTapCallback(ref, _id);
  }

  @override
  Widget build(BuildContext ctx, WidgetRef ref) {
    final theme = Theme.of(ctx);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        onTap: () => _onTap(ref),
        borderRadius: BorderRadius.circular(16),
        child: Consumer(
          builder: (context, ref, child) {
            final playing = ref.watch(
              sentenceCardProvider(_id).select((st) => st.playing),
            );
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              decoration: BoxDecoration(
                color: playing
                    ? colorScheme.primaryContainer.withValues(alpha: 0.8)
                    : colorScheme.surface,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(playing ? 4 : 16),
                ),
                boxShadow: playing
                    ? [
                        BoxShadow(
                          color: colorScheme.primary.withValues(alpha: 0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
                border: Border.all(
                  color: playing
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
                        final (text, playing) = ref.watch(
                          sentenceCardProvider(
                            _id,
                          ).select((st) => (st.text, st.playing)),
                        );
                        return Text(
                          text,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: playing
                                ? colorScheme.onPrimaryContainer
                                : colorScheme.onSurface,
                            fontSize: 16,
                            height: 1.4,
                            fontWeight: playing
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
                            final (period, playing) = ref.watch(
                              sentenceCardProvider(
                                _id,
                              ).select((st) => (st.period, st.playing)),
                            );
                            return Text(
                              period,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: playing
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
