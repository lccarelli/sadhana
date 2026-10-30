import 'package:flutter_test/flutter_test.dart';

import '../support/recorder_harness.dart';

void main() {
  useRecorderHarness();

  group('recording a practice', () {
    test('writes the row at the first breath, not at the end', () async {
      final r = recorder();
      await r.begin(sequence);

      final session = await onlySession();
      expect(session.sequenceId, 'seq.slow_morning');
      expect(session.startedAt, clock);
      expect(session.plannedSeconds, 1452);
      expect(session.endedAt, isNull, reason: 'still running');
      expect(session.completed, isFalse);
    });

    test(
      'begin is idempotent — no duplicate row on a re-entered screen',
      () async {
        final r = recorder();
        await r.begin(sequence);
        await r.begin(sequence);

        expect(await db.select(db.sessions).get(), hasLength(1));
      },
    );

    test('checkpoints on a throttle, not every frame', () async {
      final r = recorder();
      await r.begin(sequence);

      for (var i = 1; i <= 60; i++) {
        await r.checkpoint(Duration(milliseconds: i * 100));
      }
      expect((await onlySession()).practisedSeconds, 0);

      await r.checkpoint(const Duration(seconds: 31));
      expect((await onlySession()).practisedSeconds, 31);
    });

    test('a forced checkpoint bypasses the throttle', () async {
      final r = recorder();
      await r.begin(sequence);

      await r.checkpoint(const Duration(seconds: 4), force: true);
      expect((await onlySession()).practisedSeconds, 4);
    });

    test(
      'finishing records the practised time and the completed flag',
      () async {
        final r = recorder();
        await r.begin(sequence);

        clock = clock.add(const Duration(minutes: 24));
        final id = await r.end(
          practised: const Duration(seconds: 1452),
          completed: true,
        );

        final session = await onlySession();
        expect(id, session.id);
        expect(session.completed, isTrue);
        expect(session.practisedSeconds, 1452);
        expect(session.endedAt, clock);
      },
    );

    test(
      'end is idempotent — completion, backgrounding and dispose all call it',
      () async {
        final r = recorder();
        await r.begin(sequence);

        await r.end(practised: const Duration(minutes: 8), completed: false);
        await r.end(practised: const Duration(minutes: 24), completed: true);

        final session = await onlySession();
        expect(
          session.practisedSeconds,
          8 * 60,
          reason: 'the first close wins; later calls must not rewrite history',
        );
        expect(session.completed, isFalse);
      },
    );

    test('an abandoned practice is still a practice', () async {
      final r = recorder();
      await r.begin(sequence);
      await r.checkpoint(const Duration(minutes: 8), force: true);
      await r.end(practised: const Duration(minutes: 8), completed: false);

      final session = await onlySession();
      expect(session.practisedSeconds, 480);
      expect(session.completed, isFalse);
      expect(session.endedAt, isNotNull);
    });
  });
}
