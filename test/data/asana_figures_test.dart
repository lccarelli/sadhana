import 'package:flutter_test/flutter_test.dart';
import 'package:sadhana/core/domain/asana.dart';
import 'package:sadhana/data/corpus/asana_catalogue.dart';

void main() {
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

    test('can light up every muscle the posture claims', () {
      for (final asana in AsanaCatalogue.asanas) {
        for (final muscle in asana.muscles) {
          expect(
            asana.figure.markFor(muscle.group),
            isNotNull,
            reason:
                '${asana.id} lists ${muscle.group.name} but the figure '
                'has nowhere to light it',
          );
        }
      }
    });

    test('has no mark that can never light', () {
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
}
