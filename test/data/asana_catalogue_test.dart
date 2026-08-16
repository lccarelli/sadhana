import 'package:flutter_test/flutter_test.dart';
import 'package:sadhana/app/locale_controller.dart';
import 'package:sadhana/core/domain/anga.dart';
import 'package:sadhana/core/domain/asana.dart';
import 'package:sadhana/core/domain/practice_sequence.dart';
import 'package:sadhana/core/domain/practice_step.dart';
import 'package:sadhana/data/corpus/asana_catalogue.dart';
import 'package:sadhana/data/sadhana/step_codec.dart';

void main() {
  final locales = LocaleController.supported.map((l) => l.languageCode);

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
            reason: '${asana.id} falls back in $code instead of being '
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

  group('the figures', () {
    test('stay inside the design box', () {
      for (final asana in AsanaCatalogue.asanas) {
        final points = [
          ...asana.figure.strokes.expand((s) => s),
          asana.figure.head,
        ];
        for (final p in points) {
          expect(
            p.x,
            inInclusiveRange(0, AsanaFigure.designWidth),
            reason: '${asana.id} has a point off the canvas',
          );
          expect(
            p.y,
            inInclusiveRange(0, AsanaFigure.designHeight),
            reason: '${asana.id} has a point off the canvas',
          );
        }
      }
    });

    test('are drawable — every stroke is at least a line', () {
      for (final asana in AsanaCatalogue.asanas) {
        expect(asana.figure.strokes, isNotEmpty, reason: asana.id);
        for (final stroke in asana.figure.strokes) {
          expect(
            stroke.length,
            greaterThanOrEqualTo(2),
            reason: '${asana.id} has a stroke with a single point',
          );
        }
        expect(asana.figure.headRadius, greaterThan(0), reason: asana.id);
      }
    });

    /// The whole point of drawing rather than shipping an image is that
    /// tapping a muscle lights it up. A muscle listed with nowhere to light
    /// is a dead tap.
    test('can light up every muscle the posture claims', () {
      for (final asana in AsanaCatalogue.asanas) {
        for (final muscle in asana.muscles) {
          expect(
            asana.figure.markFor(muscle.group),
            isNotNull,
            reason: '${asana.id} lists ${muscle.group.name} but the figure '
                'has nowhere to light it',
          );
        }
      }
    });

    test('has no mark that can never light', () {
      // The other direction of the same rule: a mark with no muscle listed
      // renders faintly forever and is never explained. Dead weight nobody
      // will ever delete.
      for (final asana in AsanaCatalogue.asanas) {
        final listed = asana.muscles.map((m) => m.group).toSet();
        for (final mark in asana.figure.marks) {
          expect(
            listed,
            contains(mark.group),
            reason: '${asana.id} draws ${mark.group.name} but never names it',
          );
        }
      }
    });

    test('marks have real area', () {
      for (final asana in AsanaCatalogue.asanas) {
        for (final mark in asana.figure.marks) {
          expect(mark.rx, greaterThan(0), reason: asana.id);
          expect(mark.ry, greaterThan(0), reason: asana.id);
        }
      }
    });

    test('every posture has something to feel — at least one primary', () {
      for (final asana in AsanaCatalogue.asanas) {
        expect(
          asana.muscles.where((m) => m.primary),
          isNotEmpty,
          reason: '${asana.id} highlights nothing by default',
        );
      }
    });

    test('separates what stretches from what engages', () {
      for (final asana in AsanaCatalogue.asanas) {
        expect(
          asana.stretches.length + asana.engages.length,
          asana.muscles.length,
          reason: asana.id,
        );
      }
    });
  });

  group('the two halves agree', () {
    test('every posture in a shipped practice exists in the catalogue', () {
      for (final sequence in PracticeSequence.seeds) {
        for (final step in sequence.steps.whereType<AsanaStep>()) {
          expect(
            AsanaCatalogue.byId(step.asanaId),
            isNotNull,
            reason: '${sequence.id} uses ${step.asanaId}, which the body '
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
