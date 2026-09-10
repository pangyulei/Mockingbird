import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockingbird/mobile/tab_settings/about/about_bloc.dart';
import 'package:mockingbird/mobile/tab_settings/about/about_event.dart';

class AboutUI extends StatelessWidget {
  const AboutUI({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return BlocProvider(
      create: (context) => AboutBloc()..add(const AboutInitEvent()),
      child: Scaffold(
        appBar: AppBar(title: const Text('About')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.auto_stories_rounded, size: 80, color: colorScheme.primary),
              ),
              const SizedBox(height: 24),
              Builder(
                builder: (context) {
                  final appName = context.select<AboutBloc, String>((bloc) => bloc.state.appName);
                  return Text(
                    appName,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  );
                },
              ),
              const SizedBox(height: 8),
              Builder(
                builder: (context) {
                  final version = context.select<AboutBloc, String>((bloc) => bloc.state.version);
                  return Text(
                    'Version $version',
                    style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.outline),
                  );
                },
              ),
              const SizedBox(height: 32),
              Text(
                'A language shadowing app designed to help you master new languages through deliberate practice.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(height: 1.5),
              ),
              const SizedBox(height: 48),
              _contactSection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _contactSection(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'CONTACT DEVELOPER',
          style: theme.textTheme.labelMedium?.copyWith(
            color: colorScheme.primary,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 16),
        _contactItem(
          context,
          icon: Icons.email_outlined,
          label: 'Gmail',
          value: 'pangyulei@gmail.com',
        ),
        const SizedBox(height: 12),
        _contactItem(context, icon: Icons.chat_bubble_outline, label: 'QQ频道', value: 'm0ckingbird'),
      ],
    );
  }

  Widget _contactItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: () {
        Clipboard.setData(ClipboardData(text: value));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '$label copied to clipboard',
              style: TextStyle(color: colorScheme.onSurface),
            ),
            behavior: SnackBarBehavior.floating,
            backgroundColor: colorScheme.surfaceContainerHighest,
          ),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colorScheme.outline.withValues(alpha: 0.1)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 24, color: colorScheme.primary),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(
                    context,
                  ).textTheme.labelSmall?.copyWith(color: colorScheme.outline),
                ),
                Text(
                  value,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const Spacer(),
            Icon(Icons.copy_rounded, size: 18, color: colorScheme.outline),
          ],
        ),
      ),
    );
  }
}
