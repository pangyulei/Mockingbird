import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mockingbird/app/app_route.dart';

class SettingsUI extends StatelessWidget {
  const SettingsUI({super.key});

  @override
  Widget build(BuildContext context) {
    return _page(context);
  }

  AppBar _appBar() {
    return AppBar(title: const Text('Settings'));
  }

  Widget _page(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: ListView(
        children: [
          _sectionHeader(context, 'Playback'),
          // Consumer(
          //   builder: (context, ref, child) {
          //     final bool? loop = ref.watch(
          //       settingsProvider.select((st) => st.value?.loop),
          //     );
          //     if (loop == null) return const SizedBox.shrink();
          //     return SwitchListTile(
          //       title: const Text('Default Loop Mode'),
          //       subtitle: const Text('Loop current sentence by default'),
          //       value: loop,
          //       onChanged: (_) => _onToggleLoop(ref),
          //       activeThumbColor: Theme.of(context).colorScheme.primary,
          //     );
          //   },
          // ),
          const Divider(),
          _sectionHeader(context, 'Support'),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About Mockingbird'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _onTapAbout(context),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  void _onTapAbout(BuildContext context) {
    context.push(AppRoute.about);
  }
}
