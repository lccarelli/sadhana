import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../design_system/app_theme.dart';
import '../design_system/tokens.dart';
import '../features/shell/app_shell.dart';
import '../l10n/generated/app_localizations.dart';
import 'providers.dart';

class SadhanaApp extends ConsumerWidget {
  const SadhanaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeControllerProvider);
    final locale = ref.watch(localeControllerProvider);

    return MaterialApp(
      onGenerateTitle: (context) => L.of(context).appName,
      debugShowCheckedModeBanner: false,

      // Both themes are always built; the controller only picks which one is
      // in effect. Flutter then cross-fades between them over a full beat,
      // which is the whole reason the clock rule is bearable.
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: theme.brightness == Brightness.dark
          ? ThemeMode.dark
          : ThemeMode.light,
      themeAnimationDuration: Beat.beat,
      themeAnimationCurve: Beat.ease,

      locale: locale.locale,
      localizationsDelegates: L.localizationsDelegates,
      supportedLocales: L.supportedLocales,

      home: const AppShell(),
    );
  }
}
