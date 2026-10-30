import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sadhana/core/domain/practice_sequence.dart';
import 'package:sadhana/data/sadhana/database.dart';
import 'package:sadhana/data/sadhana/practice_recorder.dart';

late SadhanaDatabase db;
late DateTime clock;

final sequence = PracticeSequence.slowMorning;

PracticeRecorder recorder({Duration? every}) => PracticeRecorder(
  db,
  now: () => clock,
  checkpointEvery: every ?? const Duration(seconds: 30),
);

Future<Session> onlySession() async =>
    (await db.select(db.sessions).get()).single;

void useRecorderHarness() {
  setUp(() {
    db = SadhanaDatabase(NativeDatabase.memory());
    clock = DateTime(2026, 8, 16, 6, 30);
  });
  tearDown(() => db.close());
}
