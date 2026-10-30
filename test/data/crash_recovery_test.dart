import 'package:flutter_test/flutter_test.dart';
import 'package:sadhana/data/sadhana/database.dart';

import '../support/recorder_harness.dart';

void main() {
  useRecorderHarness();

  group('crash recovery', () {
    test('a session left open by a kill is closed on next launch', () async {
      final r = recorder();
      await r.begin(sequence);
      await r.checkpoint(const Duration(minutes: 12), force: true);

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
}
