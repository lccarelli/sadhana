import 'package:flutter_test/flutter_test.dart';
import 'package:sadhana/data/sadhana/database.dart';

import '../support/recorder_harness.dart';

void main() {
  useRecorderHarness();

  group('text encounters', () {
    test(
      'count once per session, however many frames the step lasts',
      () async {
        final r = recorder();
        await r.begin(sequence);

        for (var i = 0; i < 30; i++) {
          await r.noteTextEncounter('ys.1.2');
        }

        expect(await db.encounterCount('ys.1.2'), 1);
      },
    );

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
}
