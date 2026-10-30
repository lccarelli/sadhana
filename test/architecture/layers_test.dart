import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

final _importPattern = RegExp(
  r'''^(?:import|export)\s+'([^']+)';''',
  multiLine: true,
);

Iterable<String> dartFilesUnder(String folder) =>
    Directory(p.join('lib', folder))
        .listSync(recursive: true)
        .whereType<File>()
        .map((f) => f.path)
        .where((path) => path.endsWith('.dart') && !path.endsWith('.g.dart'));

Iterable<String> importsOf(String file) sync* {
  for (final match in _importPattern.allMatches(
    File(file).readAsStringSync(),
  )) {
    final uri = match.group(1)!;
    if (uri.startsWith('package:sadhana/')) {
      yield uri.substring('package:sadhana/'.length);
    } else if (uri.contains(':')) {
      yield uri;
    } else {
      yield p.relative(p.normalize(p.join(p.dirname(file), uri)), from: 'lib');
    }
  }
}

Map<String, List<String>> violations(
  String folder,
  bool Function(String) forbidden,
) => {
  for (final file in dartFilesUnder(folder))
    if (importsOf(file).where(forbidden).toList() case final bad
        when bad.isNotEmpty)
      file: bad,
};

void main() {
  test('core imports no Flutter and nothing outside core', () {
    expect(
      violations(
        'core',
        (uri) =>
            uri.startsWith('package:flutter') ||
            !(uri.startsWith('core/') || uri.startsWith('dart:')),
      ),
      isEmpty,
    );
  });

  test('data never reaches into the UI', () {
    expect(
      violations(
        'data',
        (uri) =>
            uri.startsWith('features/') ||
            uri.startsWith('design_system/') ||
            uri.startsWith('app/'),
      ),
      isEmpty,
    );
  });

  test('corpus and sadhana never import each other', () {
    expect(
      violations('data/corpus', (uri) => uri.startsWith('data/sadhana/')),
      isEmpty,
    );
    expect(
      violations('data/sadhana', (uri) => uri.startsWith('data/corpus/')),
      isEmpty,
    );
  });

  test('the design system knows no feature', () {
    expect(
      violations('design_system', (uri) => uri.startsWith('features/')),
      isEmpty,
    );
  });
}
