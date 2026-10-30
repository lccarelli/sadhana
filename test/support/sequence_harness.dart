import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sadhana/core/domain/breath.dart';
import 'package:sadhana/core/domain/practice_step.dart';
import 'package:sadhana/data/sadhana/database.dart';
import 'package:sadhana/data/sadhana/sequence_repository.dart';

late SadhanaDatabase db;
late SequenceRepository repo;

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

void useSequenceHarness() {
  setUp(() {
    db = SadhanaDatabase(NativeDatabase.memory());
    repo = SequenceRepository(db);
  });
  tearDown(() => db.close());
}
