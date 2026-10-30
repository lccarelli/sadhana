import 'package:flutter_test/flutter_test.dart';
import 'package:sadhana/core/domain/practice_sequence.dart';
import 'package:sadhana/core/domain/practice_step.dart';

import '../support/sequence_harness.dart';

void main() {
  useSequenceHarness();

  group('shipped practices', () {
    test('are offered alongside the practitioner\'s own', () async {
      await repo.save(title: 'mine', steps: oneOfEach);
      final all = await repo.watchAll().first;

      expect(
        all.where((s) => !s.authoredByUser).map((s) => s.id),
        containsAll(PracticeSequence.seeds.map((s) => s.id)),
      );
      expect(all.where((s) => s.authoredByUser).single.title, 'mine');
    });

    test('are resolvable by id without touching the database', () async {
      final seeded = await repo.byId('seq.slow_morning');
      expect(seeded, isNotNull);
      expect(seeded!.authoredByUser, isFalse);
      expect(seeded.storageId, isNull);
    });

    test('editing one makes a copy and leaves the original alone', () async {
      final original = PracticeSequence.slowMorning;
      final copy = await repo.duplicate(original, title: 'my slow morning');

      expect(copy.authoredByUser, isTrue);
      expect(copy.storageId, isNotNull);
      expect(copy.steps.length, original.steps.length);

      await repo.save(
        storageId: copy.storageId,
        title: 'my slow morning',
        steps: const [SilenceStep(duration: Duration(minutes: 2))],
      );

      final seeded = await repo.byId('seq.slow_morning');
      expect(seeded!.steps.length, original.steps.length);
      expect(PracticeSequence.slowMorning.steps.length, original.steps.length);
    });

    test('cannot be deleted', () async {
      await repo.delete(PracticeSequence.slowMorning);
      expect(await repo.byId('seq.slow_morning'), isNotNull);
    });
  });
}
