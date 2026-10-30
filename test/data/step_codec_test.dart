import 'package:flutter_test/flutter_test.dart';
import 'package:sadhana/core/domain/practice_step.dart';
import 'package:sadhana/data/sadhana/sequence_repository.dart';
import 'package:sadhana/data/sadhana/step_codec.dart';

import '../support/sequence_harness.dart';

void main() {
  useSequenceHarness();

  group('step codec', () {
    test('round-trips every kind without losing a field', () async {
      final saved = await repo.save(title: 'everything', steps: oneOfEach);
      final loaded = await repo.byId(saved.id);

      expect(loaded, isNotNull);
      expect(loaded!.steps, hasLength(oneOfEach.length));

      final breath = loaded.steps[0] as BreathStep;
      expect(breath.pattern.inhale, 5);
      expect(breath.pattern.holdIn, 3);
      expect(breath.pattern.exhale, 9);
      expect(breath.pattern.holdOut, 2);
      expect(breath.cycles, 7);

      final asana = loaded.steps[1] as AsanaStep;
      expect(asana.asanaId, 'asana.virabhadrasana_ii');
      expect(asana.hold, const Duration(seconds: 75));
      expect(asana.side, BodySide.left);

      final focus = loaded.steps[2] as FocusStep;
      expect(focus.object, 'the space between the eyebrows');
      expect(focus.duration, const Duration(minutes: 4));

      expect(
        (loaded.steps[3] as SilenceStep).duration,
        const Duration(minutes: 11),
      );

      final reading = loaded.steps[4] as ReadingStep;
      expect(reading.textId, 'ys.3.4');
      expect(reading.duration, const Duration(seconds: 150));
    });

    test('preserves a symmetric posture as having no side', () async {
      final saved = await repo.save(
        title: 'symmetric',
        steps: const [
          AsanaStep(asanaId: 'asana.tadasana', hold: Duration(seconds: 30)),
        ],
      );

      final loaded = await repo.byId(saved.id);
      expect((loaded!.steps.single as AsanaStep).side, isNull);
    });

    test(
      'refuses a kind it does not know instead of dropping the step',
      () async {
        final saved = await repo.save(title: 'x', steps: oneOfEach);
        final storageId = SequenceRepository.storageIdOf(saved.id)!;

        await db.customStatement(
          'UPDATE step_rows SET kind = ? WHERE sequence_id = ? AND position = 0',
          ['levitation', storageId],
        );

        expect(() => repo.byId(saved.id), throwsArgumentError);
      },
    );

    test('every step kind has a blank the editor can start from', () {
      for (final kind in StepKind.values) {
        final blank = StepCodec.blank(kind);
        expect(StepCodec.kindOf(blank), kind);
        expect(
          blank.duration,
          greaterThan(Duration.zero),
          reason: 'a zero-length $kind reads as a bug on the mat',
        );
      }
    });
  });
}
