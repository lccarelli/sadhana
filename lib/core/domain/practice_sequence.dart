import 'anga.dart';
import 'breath.dart';
import 'practice_step.dart';

class PracticeSequence {
  PracticeSequence({
    required this.id,
    required this.title,
    required this.steps,
    this.authoredByUser = false,
    this.storageId,
  }) : assert(steps.isNotEmpty, 'a practice with no steps is not a practice');

  final String id;

  final String title;

  final List<PracticeStep> steps;
  final bool authoredByUser;

  final int? storageId;

  PracticeSequence copyWith({String? title, List<PracticeStep>? steps}) =>
      PracticeSequence(
        id: id,
        title: title ?? this.title,
        steps: steps ?? this.steps,
        authoredByUser: authoredByUser,
        storageId: storageId,
      );

  Duration get duration =>
      steps.fold(Duration.zero, (sum, s) => sum + s.duration);

  Set<Anga> get angas => steps.expand((s) => s.angas).toSet();

  Duration offsetOf(int index) =>
      steps.take(index).fold(Duration.zero, (sum, s) => sum + s.duration);

  static List<PracticeSequence> get seeds => [slowMorning, eveningUnwind];

  static PracticeSequence get eveningUnwind => PracticeSequence(
    id: 'seq.evening_unwind',
    title: 'seqEveningUnwind',
    steps: [
      const BreathStep(pattern: BreathPattern.calming, cycles: 8),
      const FocusStep(
        object: 'focusBreathAtNostrils',
        duration: Duration(minutes: 4),
      ),
      const SilenceStep(duration: Duration(minutes: 8)),
    ],
  );

  static PracticeSequence get slowMorning => PracticeSequence(
    id: 'seq.slow_morning',
    title: 'seqSlowMorning',
    steps: [
      const BreathStep(pattern: BreathPattern.nadiShodhana, cycles: 12),
      const AsanaStep(
        asanaId: 'asana.trikonasana',
        hold: Duration(minutes: 1),
        side: BodySide.right,
      ),
      const AsanaStep(
        asanaId: 'asana.trikonasana',
        hold: Duration(minutes: 1),
        side: BodySide.left,
      ),
      const ReadingStep(textId: 'ys.1.2', duration: Duration(minutes: 3)),
      const FocusStep(
        object: 'focusBreathAtNostrils',
        duration: Duration(minutes: 6),
      ),
      const SilenceStep(duration: Duration(minutes: 10)),
    ],
  );
}
