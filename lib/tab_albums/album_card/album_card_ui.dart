import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockingbird/tab_albums/album_card/album_card_bloc.dart';
import 'package:mockingbird/tab_albums/album_card/album_card_event.dart';

class AlbumCardUI extends StatelessWidget {
  final AlbumCardBloc _bloc;
  const AlbumCardUI(this._bloc, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocProvider.value(
      value: _bloc,
      child: Builder(
        builder: (context) => InkWell(
          onTap: () =>
              context.read<AlbumCardBloc>().add(AlbumCardClickEvent(context)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Cover image area
              Icon(
                Icons.folder_rounded,
                color: colorScheme.primary.withValues(alpha: 0.5),
                size: 56,
              ),
              // Name and song count below cover
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Builder(
                      builder: (context) {
                        final name = context.select<AlbumCardBloc, String>(
                          (bloc) => bloc.state.name,
                        );
                        return Text(
                          name,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.2,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        );
                      },
                    ),
                    const SizedBox(height: 2),
                    Builder(
                      builder: (context) {
                        final mediaCount = context.select<AlbumCardBloc, int>(
                          (bloc) => bloc.state.mediaCount,
                        );
                        return Text(
                          '$mediaCount Medias',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.outline,
                            fontWeight: FontWeight.w500,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
