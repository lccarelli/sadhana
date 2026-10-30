import 'package:flutter_test/flutter_test.dart';
import 'package:sadhana/core/domain/anga.dart';
import 'package:sadhana/core/domain/practice_sequence.dart';
import 'package:sadhana/core/domain/practice_step.dart';
import 'package:sadhana/data/corpus/asana_catalogue.dart';
import 'package:sadhana/data/sadhana/step_codec.dart';

import '../support/locales.dart';

void main() {
  group('the catalogue', () {
    test('gives every posture an id, devanagari and transliteration', () {
      for (final asana in AsanaCatalogue.asanas) {
        expect(asana.id, startsWith('asana.'));
        expect(asana.devanagari, isNotEmpty, reason: asana.id);
        expect(asana.iast, isNotEmpty, reason: asana.id);
        expect(asana.angas, contains(Anga.asana));
      }
    });

    test('has no duplicate ids', () {
      final ids = AsanaCatalogue.asanas.map((a) => a.id).toList();
      expect(ids.toSet(), hasLength(ids.length));
    });

    test('names every posture in every language the app speaks', () {
      for (final asana in AsanaCatalogue.asanas) {
        for (final code in locales) {
          final translation = AsanaCatalogue.translation(asana.id, code);
          expect(
            translation?.localeCode,
            code,
            reason:
                '${asana.id} falls back in $code instead of being '
                'translated',
          );
          expect(translation!.name, isNotEmpty);
        }
      }
    });

    test('falls back rather than showing a blank name', () {
      final pt = AsanaCatalogue.translation('asana.trikonasana', 'pt');
      expect(pt, isNotNull);
      expect(pt!.localeCode, 'en');
    });

    test('returns null for a posture it does not ship', () {
      expect(AsanaCatalogue.byId('asana.nonexistent'), isNull);
    });
  });

  group('the two halves agree', () {
    test('every posture in a shipped practice exists in the catalogue', () {
      for (final sequence in PracticeSequence.seeds) {
        for (final step in sequence.steps.whereType<AsanaStep>()) {
          expect(
            AsanaCatalogue.byId(step.asanaId),
            isNotNull,
            reason:
                '${sequence.id} uses ${step.asanaId}, which the body '
                'screen cannot draw and the runner cannot name',
          );
        }
      }
    });

    test('the editor starts new posture steps from a real posture', () {
      final blank = StepCodec.blank(StepKind.asana) as AsanaStep;
      expect(AsanaCatalogue.byId(blank.asanaId), isNotNull);
    });
  });
}
