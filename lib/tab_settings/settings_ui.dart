import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mockingbird/app/app_route.dart';
import 'package:mockingbird/tab_settings/settings_provider.dart';

class SettingsUI extends ConsumerWidget {
  const SettingsUI({super.key});

  @override
  Widget build(BuildContext ctx, WidgetRef ref) {
    final theme = Theme.of(ctx);
    final colorScheme = theme.colorScheme;
    final asyncState = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: asyncState.when(
        data: (state) => ListView(
          children: [
            _sectionHeader(ctx, 'Playback'),
            SwitchListTile(
              title: const Text('Default Loop Mode'),
              subtitle: const Text('Loop current sentence by default'),
              value: state.loop,
              onChanged: (_) => _onToggleLoop(ref),
              activeColor: colorScheme.primary,
            ),
            const Divider(),
            _sectionHeader(ctx, 'Support'),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('About Mockingbird'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _onTapAbout(ctx),
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _sectionHeader(BuildContext ctx, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(ctx).textTheme.labelMedium?.copyWith(
          color: Theme.of(ctx).colorScheme.primary,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  void _onToggleLoop(WidgetRef ref) async {
    await ref.read(settingsProvider.notifier).toggleLoop();
  }

  void _onTapAbout(BuildContext ctx) {
    ctx.push(AppRoute.about);
  }
}
