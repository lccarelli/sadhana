import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sadhana/core/domain/breath.dart';
import 'package:sadhana/core/domain/practice_sequence.dart';
import 'package:sadhana/core/domain/practice_step.dart';
import 'package:sadhana/core/usecases/session_runner.dart';
import 'package:sadhana/data/sadhana/database.dart';
import 'package:sadhana/data/sadhana/sequence_repository.dart';
import 'package:sadhana/data/sadhana/step_codec.dart';

void main() {
  late SadhanaDatabase db;
  late SequenceRepository repo;

  setUp(() {
    db = SadhanaDatabase(NativeDatabase.memory());
    repo = SequenceRepository(db);
  });

  tearDown(() => db.close());

  /// One of every kind, with values that are not the defaults — a codec bug
  /// that silently substitutes a fallback would pass against defaults.
  final oneOfEach = <PracticeStep>[
    const BreathStep(
      pattern: BreathPattern(inhale: 5, holdIn: 3, exhale: 9, holdOut: 2),
      cycles: 7,
    ),
    const AsanaStep(
      asanaId: 'asana.virabhadrasana_ii',
      hold: Duration(seconds: 75),
      side: BodySide.left,
    ),
    const FocusStep(
      object: 'the space between the eyebrows',
      duration: Duration(minutes: 4),
    ),
    const SilenceStep(duration: Duration(minutes: 11)),
    const ReadingStep(textId: 'ys.3.4', duration: Duration(seconds: 150)),
  ];

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

    test('refuses a kind it does not know instead of dropping the step',
        () async {
      // A database written by a newer version. Silently handing back a
      // practice with a hole in it would sit someone in a silence that was
      // meant to be a reading.
      final saved = await repo.save(title: 'x', steps: oneOfEach);
      final storageId = SequenceRepository.storageIdOf(saved.id)!;

      await db.customStatement(
        'UPDATE step_rows SET kind = ? WHERE sequence_id = ? AND position = 0',
        ['levitation', storageId],
      );

      expect(() => repo.byId(saved.id), throwsArgumentError);
    });

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

  group('composing', () {
    test('order survives a round trip', () async {
      final saved = await repo.save(title: 'ordered', steps: oneOfEach);
      final loaded = await repo.byId(saved.id);

      expect(
        loaded!.steps.map(StepCodec.kindOf),
        oneOfEach.map(StepCodec.kindOf),
      );
    });

    test('reordering rewrites positions rather than leaving two step threes',
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
    });

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

      // Change the copy hard, then check the shipped one is untouched — a
      // practice someone has done for a year must not shift because we
      // improved ours, and vice versa.
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
        steps: const [
          BreathStep(pattern: BreathPattern.samaVritti, cycles: 4),
        ],
      );

      final loaded = (await repo.byId(saved.id))!;
      expect(loaded.angas.map((a) => a.name), ['pranayama']);
    });
  });
}
