import 'anga.dart';
import 'breath.dart';
import 'practice_step.dart';

/// An ordered practice. Authored by us as a seed, or composed by the
/// practitioner — the runner cannot tell the difference, and that is the
/// point.
class PracticeSequence {
  PracticeSequence({
    required this.id,
    required this.title,
    required this.steps,
    this.authoredByUser = false,
    this.storageId,
  }) : assert(steps.isNotEmpty, 'a practice with no steps is not a practice');

  final String id;

  /// User-authored titles are literal. Seeded titles are localization keys,
  /// resolved at the UI edge — see [authoredByUser].
  final String title;

  final List<PracticeStep> steps;
  final bool authoredByUser;

  /// Row id for user-authored practices, null for seeded ones.
  final int? storageId;

  PracticeSequence copyWith({
    String? title,
    List<PracticeStep>? steps,
  }) =>
      PracticeSequence(
        id: id,
        title: title ?? this.title,
        steps: steps ?? this.steps,
        authoredByUser: authoredByUser,
        storageId: storageId,
      );

  Duration get duration =>
      steps.fold(Duration.zero, (sum, s) => sum + s.duration);

  /// Every limb this practice touches. Drives the chips on the Today card
  /// and, over time, which parts of the path a practitioner actually walks.
  Set<Anga> get angas => steps.expand((s) => s.angas).toSet();

  /// Cumulative offset at which [index] begins.
  Duration offsetOf(int index) =>
      steps.take(index).fold(Duration.zero, (sum, s) => sum + s.duration);

  /// Practices we ship. They stay in code rather than being seeded into the
  /// database so they can be improved in a release without touching — or
  /// having to migrate — anyone's own practices.
  static List<PracticeSequence> get seeds => [slowMorning, eveningUnwind];

  /// Short, and entirely inner. The counterpart to [slowMorning]: something
  /// that can be done at 22:40 without getting the mat out.
  static PracticeSequence get eveningUnwind => PracticeSequence(
        id: 'seq.evening_unwind',
        title: 'seqEveningUnwind',
        steps: [
          // 4:7:8 — the long exhale is the point.
          const BreathStep(pattern: BreathPattern.calming, cycles: 8),
          const FocusStep(
            object: 'focusBreathAtNostrils',
            duration: Duration(minutes: 4),
          ),
          const SilenceStep(duration: Duration(minutes: 8)),
        ],
      );

  /// A slow morning. Seeded content — [title] is a localization key.
  ///
  /// Six steps, 24 minutes, walking outward to inward: breath, posture,
  /// study, fixed attention, silence. The duration is never written down
  /// anywhere — the Today card computes it from these steps, so the number on
  /// screen cannot drift away from what actually happens.
  static PracticeSequence get slowMorning => PracticeSequence(
        id: 'seq.slow_morning',
        title: 'seqSlowMorning',
        steps: [
          // 12 cycles of 4:4:8 — 3:12
          const BreathStep(
            pattern: BreathPattern.nadiShodhana,
            cycles: 12,
          ),
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
          const ReadingStep(
            textId: 'ys.1.2',
            duration: Duration(minutes: 3),
          ),
          const FocusStep(
            object: 'focusBreathAtNostrils',
            duration: Duration(minutes: 6),
          ),
          const SilenceStep(duration: Duration(minutes: 10)),
        ],
      );
}
