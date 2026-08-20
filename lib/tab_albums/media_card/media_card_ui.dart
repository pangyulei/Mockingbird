import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marquee/marquee.dart';
import 'package:mockingbird/tab_albums/media_card/media_card_bloc.dart';
import 'package:mockingbird/tab_albums/media_card/media_card_event.dart';

class MediaCardUI extends StatelessWidget {
  final String _id;

  const MediaCardUI(this._id, {super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MediaCardBloc(_id)..add(const MediaCardInitEvent()),
      child: Builder(
        builder: (context) {
          final theme = Theme.of(context);
          final colorScheme = theme.colorScheme;
          final playing = context.select<MediaCardBloc, bool>(
            (bloc) => bloc.state.playing,
          );
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: playing
                  ? colorScheme.primaryContainer.withValues(alpha: 0.15)
                  : colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: playing
                    ? colorScheme.primary.withValues(alpha: 0.5)
                    : Colors.white.withValues(alpha: 0.05),
                width: 1,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: GestureDetector(
                onTap: () => context.read<MediaCardBloc>().add(
                  MediaCardClickEvent(context, _id),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(minHeight: 62),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [_title(), _subtitle()],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      _playButton(context),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _title() {
    return Builder(
      builder: (context) {
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;
        final (name, playing) = context.select<MediaCardBloc, (String, bool)>(
          (bloc) => (bloc.state.name, bloc.state.playing),
        );
        return (playing && name.isNotEmpty)
            ? SizedBox(
                height: 20,
                child: Marquee(
                  text: name,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                  scrollAxis: Axis.horizontal,
                  blankSpace: 20,
                  velocity: 30,
                ),
              )
            : Text(
                name,
                textAlign: TextAlign.left,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              );
      },
    );
  }

  Widget _subtitle() {
    return Builder(
      builder: (context) {
        // Mocking hasSubtitle for now, as requested.
        final hasSubtitle = context.select<MediaCardBloc, bool>(
          (bloc) => bloc.state.hasSubtitle,
        );
        if (!hasSubtitle) return const SizedBox.shrink();
        return const Padding(
          padding: EdgeInsets.only(top: 4),
          child: Row(
            children: [
              Icon(Icons.subtitles_rounded, size: 16, color: Colors.blue),
            ],
          ),
        );
      },
    );
  }

  Widget _playButton(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Builder(
      builder: (context) {
        final playing = context.select<MediaCardBloc, bool>(
          (bloc) => bloc.state.playing,
        );
        return Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: playing
                ? colorScheme.primary
                : colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            playing ? Icons.graphic_eq_rounded : Icons.play_arrow_rounded,
            color: playing ? Colors.white : colorScheme.primary,
            size: 28,
          ),
        );
      },
    );
  }
}
