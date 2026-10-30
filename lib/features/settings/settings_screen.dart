import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/locale_controller.dart';
import '../../app/providers.dart';
import '../../design_system/theme_controller.dart';
import '../../design_system/tokens.dart';
import '../../design_system/typography.dart';
import '../../design_system/widgets.dart';
import '../../l10n/l10n_x.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l;
    final c = context.colors;
    final theme = ref.watch(themeControllerProvider);
    final locale = ref.watch(localeControllerProvider);

    return Scaffold(
      appBar: AppBar(title: MonoLabel(l.settingsTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          Space.screen,
          0,
          Space.screen,
          Space.xl,
        ),
        children: [
          Hanging(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MonoLabel(l.settingsTheme),
                const SizedBox(height: Space.sm),
                RadioGroup<AppThemeMode>(
                  groupValue: theme.mode,
                  onChanged: (v) => theme.mode = v!,
                  child: Column(
                    children: [
                      for (final mode in AppThemeMode.values)
                        RadioListTile<AppThemeMode>(
                          value: mode,
                          contentPadding: EdgeInsets.zero,
                          title: Text(switch (mode) {
                            AppThemeMode.auto => l.settingsThemeAuto,
                            AppThemeMode.light => l.settingsThemeLight,
                            AppThemeMode.dark => l.settingsThemeDark,
                          }, style: AppType.uiBody.copyWith(color: c.ink)),
                          subtitle: mode == AppThemeMode.auto
                              ? Text(
                                  l.settingsThemeAutoDetail(
                                    theme.resolver.lightStartHour,
                                    theme.resolver.darkStartHour,
                                  ),
                                  style: AppType.uiBody.copyWith(
                                    fontSize: 12.5,
                                    color: c.muted,
                                  ),
                                )
                              : null,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: Space.lg),
          Hanging(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MonoLabel(l.settingsLanguage),
                const SizedBox(height: Space.sm),
                RadioGroup<Locale?>(
                  groupValue: locale.locale,
                  onChanged: locale.set,
                  child: Column(
                    children: [
                      for (final option in LocaleController.supported)
                        RadioListTile<Locale?>(
                          value: option,
                          contentPadding: EdgeInsets.zero,
                          title: Text(switch (option.languageCode) {
                            'es' => 'Español',
                            'en' => 'English',
                            _ => option.languageCode,
                          }, style: AppType.uiBody.copyWith(color: c.ink)),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: Space.lg),
          Hanging(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MonoLabel(l.settingsAbout),
                const SizedBox(height: 6),
                Text(l.appName, style: AppType.heading.copyWith(color: c.ink)),
                const SizedBox(height: 3),
                Text(
                  l.appSignature,
                  style: AppType.uiBody.copyWith(fontSize: 13, color: c.accent),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
