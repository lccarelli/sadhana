import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Guards the language architecture itself.
///
/// gen-l10n writes l10n_missing.json, but nothing fails the build over it.
/// This does. A missing key must break CI, not fall back to English in front
/// of a paying user.
void main() {
  final dir = Directory('lib/l10n');

  Map<String, dynamic> load(String file) =>
      jsonDecode(File('${dir.path}/$file').readAsStringSync())
          as Map<String, dynamic>;

  /// Keys only — the @-prefixed entries are metadata, not strings.
  Set<String> keysOf(Map<String, dynamic> arb) =>
      arb.keys.where((k) => !k.startsWith('@')).toSet();

  final template = load('app_en.arb');
  final templateKeys = keysOf(template);

  final languages = dir
      .listSync()
      .whereType<File>()
      .map((f) => f.uri.pathSegments.last)
      .where((n) => n.startsWith('app_') && n.endsWith('.arb'))
      .toList()
    ..sort();

  test('there is more than one language, or none of this was worth it', () {
    expect(languages.length, greaterThanOrEqualTo(2));
  });

  for (final file in languages) {
    group(file, () {
      final arb = load(file);
      final keys = keysOf(arb);

      test('defines every key in the template', () {
        expect(
          templateKeys.difference(keys),
          isEmpty,
          reason: 'missing keys fall back to English in production',
        );
      });

      test('defines no key the template lacks', () {
        expect(
          keys.difference(templateKeys),
          isEmpty,
          reason: 'an orphan key is dead weight nobody will ever delete',
        );
      });

      test('declares its locale', () {
        expect(arb['@@locale'], isNotNull);
      });

      test('uses the same placeholders as the template', () {
        final placeholder = RegExp(r'\{(\w+)\}');
        for (final key in templateKeys) {
          final expected = placeholder
              .allMatches(template[key] as String)
              .map((m) => m.group(1))
              .toSet();
          final actual = placeholder
              .allMatches(arb[key] as String)
              .map((m) => m.group(1))
              .toSet();
          expect(
            actual,
            expected,
            reason: '$key: placeholder mismatch crashes at runtime, not build',
          );
        }
      });
    });
  }

  test('corpus content never leaks into the UI strings', () {
    // Sutras, asana descriptions and articles belong in the database with a
    // locale column, so a new translation ships without an app release.
    // Devanagari in an .arb file is the first sign that line is being crossed.
    final devanagari = RegExp(r'[ऀ-ॿ]');
    for (final file in languages) {
      final arb = load(file);
      for (final key in keysOf(arb)) {
        expect(
          devanagari.hasMatch(arb[key] as String),
          isFalse,
          reason: '$file/$key holds sanskrit — that is corpus, not interface',
        );
      }
    }
  });
}
