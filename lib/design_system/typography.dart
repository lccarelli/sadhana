import 'package:flutter/material.dart';

abstract final class Faces {
  static const display = <String>[
    'IowanOldStyle',
    'Iowan Old Style',
    'Charter',
    'Palatino',
    'Georgia',
    'serif',
  ];

  static const ui = <String>[];

  static const mono = <String>['SF Mono', 'Menlo', 'Roboto Mono', 'monospace'];

  static const devanagari = <String>[
    'NotoSansDevanagari',
    'Devanagari Sangam MN',
    'Noto Sans Devanagari',
    'Nirmala UI',
  ];
}

abstract final class AppType {
  static const _tabular = [FontFeature.tabularFigures()];

  static const practiceTitle = TextStyle(
    fontFamilyFallback: Faces.display,
    fontSize: 28,
    height: 1.14,
    letterSpacing: -0.3,
    fontWeight: FontWeight.w400,
  );

  static const heading = TextStyle(
    fontFamilyFallback: Faces.display,
    fontSize: 19,
    height: 1.25,
    fontWeight: FontWeight.w400,
  );

  static const uiBody = TextStyle(fontSize: 15, height: 1.5);

  static const readingBody = TextStyle(
    fontFamilyFallback: Faces.display,
    fontSize: 16,
    height: 1.6,
  );

  static const label = TextStyle(
    fontFamilyFallback: Faces.mono,
    fontSize: 11,
    height: 1.4,
    letterSpacing: 1.5,
  );

  static const sanskrit = TextStyle(
    fontFamilyFallback: Faces.devanagari,
    fontSize: 19,
    height: 1.5,
  );

  static const iast = TextStyle(
    fontFamilyFallback: Faces.display,
    fontSize: 12.5,
    fontStyle: FontStyle.italic,
  );

  static const countdown = TextStyle(
    fontFamilyFallback: Faces.mono,
    fontSize: 52,
    height: 1,
    letterSpacing: -1,
    fontFeatures: _tabular,
  );

  static const phase = TextStyle(
    fontFamilyFallback: Faces.display,
    fontSize: 29,
    letterSpacing: 0.5,
  );

  static const numeric = TextStyle(
    fontFamilyFallback: Faces.mono,
    fontFeatures: _tabular,
  );

  static TextTheme textTheme(Color ink, Color ink2, Color muted) => TextTheme(
    displayLarge: practiceTitle.copyWith(color: ink),
    titleLarge: heading.copyWith(color: ink),
    bodyLarge: readingBody.copyWith(color: ink),
    bodyMedium: uiBody.copyWith(color: ink),
    bodySmall: uiBody.copyWith(fontSize: 13, color: ink2),
    labelSmall: label.copyWith(color: muted),
  );
}
