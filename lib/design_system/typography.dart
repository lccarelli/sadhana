import 'package:flutter/material.dart';

/// Four roles, no exceptions.
///
/// Families are expressed as fallback lists so the scaffold runs today on the
/// system faces. Ship-blocking follow-up: bundle a display serif and Noto
/// Sans Devanagari (see assets/fonts/README.md), because Android has neither
/// Iowan Old Style nor a guaranteed Indic face, and a silent fallback to
/// Roboto would quietly undo the whole type system.
abstract final class Faces {
  /// Long-form reading: sutras, journal entries, practice titles.
  static const display = <String>[
    'IowanOldStyle',
    'Iowan Old Style',
    'Charter',
    'Palatino',
    'Georgia',
    'serif',
  ];

  /// Things that get operated. The platform face is the honest choice here.
  static const ui = <String>[];

  /// Anything that counts time or repetitions. Always tabular.
  static const mono = <String>[
    'SF Mono',
    'Menlo',
    'Roboto Mono',
    'monospace',
  ];

  /// Sanskrit. Never translated, so never restyled either.
  static const devanagari = <String>[
    'NotoSansDevanagari',
    'Devanagari Sangam MN',
    'Noto Sans Devanagari',
    'Nirmala UI',
  ];
}

abstract final class AppType {
  static const _tabular = [FontFeature.tabularFigures()];

  /// Session and sutra titles.
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

  /// Lists, descriptions — anything operated rather than read.
  static const uiBody = TextStyle(fontSize: 15, height: 1.5);

  /// Corpus text and journal. Read slowly, so it gets the serif.
  static const readingBody = TextStyle(
    fontFamilyFallback: Faces.display,
    fontSize: 16,
    height: 1.6,
  );

  /// Angas, metadata, states.
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

  /// Transliteration sits between the devanagari and the vernacular.
  static const iast = TextStyle(
    fontFamilyFallback: Faces.display,
    fontSize: 12.5,
    fontStyle: FontStyle.italic,
  );

  /// The runner countdown. Tabular so the digits do not jitter.
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
