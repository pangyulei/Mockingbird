import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockingbird/db/entities/sentence_entity.dart';
import 'package:mockingbird/tab_player/sentence_card/sentence_card_bloc.dart';
import 'package:mockingbird/tab_player/sentence_card/sentence_card_event.dart';

class SentenceCardUI extends ConsumerWidget {
  final SentenceEntity _sentence;
  final void Function(WidgetRef ref, String id) _onTapCallback;
  const SentenceCardUI(this._sentence, this._onTapCallback, {super.key});

  void _onTap(WidgetRef ref) {
    // _onTapCallback(ref, _id);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocProvider(
      create: (context) =>
          SentenceCardBloc(_sentence)..add(const SentenceCardInitEvent()),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: InkWell(
          onTap: () => _onTap(ref),
          borderRadius: BorderRadius.circular(16),
          child: Builder(
            builder: (context) {
              final playing = context.select<SentenceCardBloc, bool>(
                (bloc) => bloc.state.playing,
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
                      Builder(
                        builder: (context) {
                          final (text, playing) = context
                              .select<SentenceCardBloc, (String, bool)>(
                                (bloc) => (bloc.state.text, bloc.state.playing),
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
                          Builder(
                            builder: (context) {
                              final (period, playing) = context
                                  .select<SentenceCardBloc, (String, bool)>(
                                    (bloc) =>
                                        (bloc.state.period, bloc.state.playing),
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
      ),
    );
  }
}
