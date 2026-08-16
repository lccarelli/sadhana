import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sadhana/core/domain/practice_sequence.dart';
import 'package:sadhana/data/sadhana/database.dart';
import 'package:sadhana/data/sadhana/practice_recorder.dart';

void main() {
  late SadhanaDatabase db;
  late DateTime clock;

  final sequence = PracticeSequence.slowMorning; // 24 min = 1452 s

  setUp(() {
    db = SadhanaDatabase(NativeDatabase.memory());
    clock = DateTime(2026, 8, 16, 6, 30);
  });

  tearDown(() => db.close());

  PracticeRecorder recorder({Duration? every}) => PracticeRecorder(
        db,
        now: () => clock,
        checkpointEvery: every ?? const Duration(seconds: 30),
      );

  Future<Session> onlySession() async => (await db.select(db.sessions).get()).single;

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

    test('begin is idempotent — no duplicate row on a re-entered screen',
        () async {
      final r = recorder();
      await r.begin(sequence);
      await r.begin(sequence);

      expect(await db.select(db.sessions).get(), hasLength(1));
    });

    test('checkpoints on a throttle, not every frame', () async {
      final r = recorder();
      await r.begin(sequence);

      // Sixty frames inside the first half-minute: no writes.
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

    test('finishing records the practised time and the completed flag',
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
    });

    test('end is idempotent — completion, backgrounding and dispose all call it',
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
    });

    test('an abandoned practice is still a practice', () async {
      // The common case: eight minutes, then the phone gets locked.
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

  group('text encounters', () {
    test('count once per session, however many frames the step lasts',
        () async {
      final r = recorder();
      await r.begin(sequence);

      for (var i = 0; i < 30; i++) {
        await r.noteTextEncounter('ys.1.2');
      }

      expect(await db.encounterCount('ys.1.2'), 1);
    });

    test('accumulate across separate practices', () async {
      for (var i = 0; i < 3; i++) {
        final r = recorder();
        await r.begin(sequence);
        await r.noteTextEncounter('ys.1.2');
        await r.end(practised: const Duration(minutes: 24), completed: true);
        clock = clock.add(const Duration(days: 1));
      }

      expect(await db.encounterCount('ys.1.2'), 3);
      expect(await db.encounterCount('ys.3.4'), 0);
    });

    test('are not recorded once the session is closed', () async {
      final r = recorder();
      await r.begin(sequence);
      await r.end(practised: Duration.zero, completed: false);
      await r.noteTextEncounter('ys.1.2');

      expect(await db.encounterCount('ys.1.2'), 0);
    });
  });

  group('crash recovery', () {
    test('a session left open by a kill is closed on next launch', () async {
      // Practice starts, checkpoints, and the process dies.
      final r = recorder();
      await r.begin(sequence);
      await r.checkpoint(const Duration(minutes: 12), force: true);

      // Next launch.
      final closed = await db.closeAbandonedSessions(
        at: clock.add(const Duration(hours: 9)),
      );

      expect(closed, 1);
      final session = await onlySession();
      expect(session.endedAt, isNotNull);
      expect(session.completed, isFalse);
      expect(
        session.practisedSeconds,
        720,
        reason: 'the last checkpoint is what survives a kill',
      );
    });

    test('leaves finished sessions alone', () async {
      final r = recorder();
      await r.begin(sequence);
      await r.end(practised: const Duration(minutes: 24), completed: true);

      final closed = await db.closeAbandonedSessions(at: clock);

      expect(closed, 0);
      expect((await onlySession()).completed, isTrue);
    });
  });

  group('reading it back', () {
    test('continuity buckets practice by day, oldest first', () async {
      final today = DateTime(2026, 8, 16, 21);

      Future<void> practise(DateTime at, int minutes) async {
        final id = await db.startSession(
          sequenceId: 'seq.slow_morning',
          at: at,
          plannedSeconds: 1452,
        );
        await db.finishSession(
          id,
          at: at,
          practisedSeconds: minutes * 60,
          completed: true,
        );
      }

      await practise(today, 20);
      await practise(today.subtract(const Duration(days: 2)), 10);
      // Two on one day should add up, not overwrite.
      await practise(today.subtract(const Duration(days: 2, hours: 6)), 5);

      final days = await db.continuity(today: today, days: 14);

      expect(days, hasLength(14));
      expect(days.last, 20 * 60, reason: 'today is the last bucket');
      expect(days[11], 15 * 60, reason: 'two sessions on one day sum');
      expect(days[12], 0, reason: 'a day off is zero, not a gap');
    });

    test('history joins each session with its entry, newest first', () async {
      final first = DateTime(2026, 8, 14, 7);
      final second = DateTime(2026, 8, 16, 7);

      final idA = await db.startSession(
        sequenceId: 'a',
        at: first,
        plannedSeconds: 600,
      );
      await db.finishSession(
        idA,
        at: first,
        practisedSeconds: 600,
        completed: true,
      );
      await db.addJournalEntry(
        JournalEntriesCompanion.insert(
          createdAt: first,
          sessionId: Value(idA),
          sthira: const Value(4),
          note: const Value('the long hold let go on its own'),
        ),
      );

      // A session with no entry at all — the common case.
      final idB = await db.startSession(
        sequenceId: 'b',
        at: second,
        plannedSeconds: 600,
      );
      await db.finishSession(
        idB,
        at: second,
        practisedSeconds: 300,
        completed: false,
      );

      final history = await db.watchHistory().first;

      expect(history.map((h) => h.session.id), [idB, idA]);
      expect(history.first.journal, isNull);
      expect(history.first.hasNote, isFalse);
      expect(history.last.journal!.sthira, 4);
      expect(history.last.hasNote, isTrue);
    });

    test('history hides practices that are still running', () async {
      await db.startSession(
        sequenceId: 'open',
        at: clock,
        plannedSeconds: 600,
      );

      expect(await db.watchHistory().first, isEmpty);
    });

    test('encounter counts come back as one map for the whole library',
        () async {
      final id = await db.startSession(
        sequenceId: 'a',
        at: clock,
        plannedSeconds: 600,
      );
      await db.addTextEncounter(textId: 'ys.1.2', sessionId: id, at: clock);
      await db.addTextEncounter(textId: 'ys.1.2', sessionId: id, at: clock);
      await db.addTextEncounter(textId: 'ys.3.4', sessionId: id, at: clock);

      expect(await db.watchEncounterCounts().first, {
        'ys.1.2': 2,
        'ys.3.4': 1,
      });
    });
  });
}
