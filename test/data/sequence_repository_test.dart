import 'package:flutter_test/flutter_test.dart';
import 'package:sadhana/core/domain/breath.dart';
import 'package:sadhana/core/domain/practice_step.dart';
import 'package:sadhana/core/usecases/session_runner.dart';
import 'package:sadhana/data/sadhana/step_codec.dart';

import '../support/sequence_harness.dart';

void main() {
  useSequenceHarness();

  group('composing', () {
    test('order survives a round trip', () async {
      final saved = await repo.save(title: 'ordered', steps: oneOfEach);
      final loaded = await repo.byId(saved.id);

      expect(
        loaded!.steps.map(StepCodec.kindOf),
        oneOfEach.map(StepCodec.kindOf),
      );
    });

    test(
      'reordering rewrites positions rather than leaving two step threes',
      () async {
        final saved = await repo.save(title: 'ordered', steps: oneOfEach);
        final reversed = oneOfEach.reversed.toList();

        await repo.save(
          storageId: saved.storageId,
          title: 'ordered',
          steps: reversed,
        );

        final loaded = await repo.byId(saved.id);
        expect(loaded!.steps, hasLength(oneOfEach.length));
        expect(
          loaded.steps.map(StepCodec.kindOf),
          reversed.map(StepCodec.kindOf),
        );
      },
    );

    test('updating in place does not create a second practice', () async {
      final saved = await repo.save(title: 'first', steps: oneOfEach);
      await repo.save(
        storageId: saved.storageId,
        title: 'renamed',
        steps: oneOfEach,
      );

      final own = await repo.watchOwn().first;
      expect(own, hasLength(1));
      expect(own.single.title, 'renamed');
    });

    test('a practice with no steps is refused', () async {
      expect(
        () => repo.save(title: 'empty', steps: const []),
        throwsArgumentError,
      );
    });

    test('deleting removes its steps too', () async {
      final saved = await repo.save(title: 'doomed', steps: oneOfEach);
      await repo.delete(saved);

      expect(await repo.watchOwn().first, isEmpty);
      expect(await db.select(db.stepRows).get(), isEmpty);
    });
  });

  group('the runner cannot tell them apart', () {
    test('a composed practice runs exactly like a shipped one', () async {
      final saved = await repo.save(title: 'mine', steps: oneOfEach);
      final loaded = (await repo.byId(saved.id))!;

      final runner = SessionRunner(loaded)..start();
      for (var i = 0; i < loaded.duration.inSeconds; i++) {
        runner.advance(const Duration(seconds: 1));
      }

      expect(runner.status, RunnerStatus.completed);
      expect(runner.snapshot.elapsedTotal, loaded.duration);
    });

    test('its limbs come out of its steps, like any other practice', () async {
      final saved = await repo.save(
        title: 'breath only',
        steps: const [BreathStep(pattern: BreathPattern.samaVritti, cycles: 4)],
      );

      final loaded = (await repo.byId(saved.id))!;
      expect(loaded.angas.map((a) => a.name), ['pranayama']);
    });
  });
}
