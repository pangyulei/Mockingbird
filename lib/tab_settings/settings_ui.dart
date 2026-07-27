import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mockingbird/app/app_route.dart';
import 'package:mockingbird/tab_settings/settings_provider.dart';
import 'package:mockingbird/tab_settings/settings_state.dart';
import 'package:mockingbird/tool/null_ui.dart';

import '../tool/extensions.dart';

class SettingsUI extends ConsumerWidget {
  const SettingsUI({super.key});

  @override
  Widget build(BuildContext ctx, WidgetRef ref) {
    final stateType = ref.watch(
      settingsProvider.select((st) => st.value?.runtimeType),
    );
    showLoading(stateType==null);
    switch (stateType) {
      case SettingsState:
        return _page(ctx);
      default:
        return Scaffold(appBar: _appBar());
    }
  }

  AppBar _appBar() {
    return AppBar(title: const Text('Settings'));
  }

  Widget _page(BuildContext ctx) {
    return Scaffold(
      appBar: _appBar(),
      body: ListView(
        children: [
          _sectionHeader(ctx, 'Playback'),
          Consumer(
            builder: (ctx, ref, child) {
              final bool? isLoop = ref.watch(
                settingsProvider.select((st) => st.value?.isLoop),
              );
              if (isLoop == null) return const NullUI();
              return SwitchListTile(
                title: const Text('Default Loop Mode'),
                subtitle: const Text('Loop current sentence by default'),
                value: isLoop,
                onChanged: (_) => _onToggleLoop(ref),
                activeThumbColor: Theme.of(ctx).colorScheme.primary,
              );
            },
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
