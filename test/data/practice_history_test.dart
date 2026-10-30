import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:sadhana/data/sadhana/database.dart';

import '../support/recorder_harness.dart';

void main() {
  useRecorderHarness();

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
      await db.startSession(sequenceId: 'open', at: clock, plannedSeconds: 600);

      expect(await db.watchHistory().first, isEmpty);
    });

    test(
      'encounter counts come back as one map for the whole library',
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
      },
    );
  });
}
