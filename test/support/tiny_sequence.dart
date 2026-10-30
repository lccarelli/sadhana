import 'package:sadhana/core/domain/breath.dart';
import 'package:sadhana/core/domain/practice_sequence.dart';
import 'package:sadhana/core/domain/practice_step.dart';

PracticeSequence tiny() => PracticeSequence(
  id: 'test.tiny',
  title: 'tiny',
  steps: const [
    BreathStep(pattern: BreathPattern(inhale: 2, exhale: 2), cycles: 2),
    SilenceStep(duration: Duration(seconds: 5)),
    AsanaStep(
      asanaId: 'asana.trikonasana',
      hold: Duration(seconds: 3),
      side: BodySide.right,
    ),
  ],
);
