import 'anga.dart';
import 'breath.dart';

/// One step of a practice.
///
/// This is the load-bearing idea of the whole app: a practice is *data*, not
/// a sequence of hardcoded screens. One runner interprets every kind of step,
/// so pranayama, vinyasa, meditation and yoga nidra all work without new
/// code — and a practitioner can compose their own sequences.
///
/// Sealed so that adding a step kind breaks every switch at compile time
/// instead of silently rendering nothing.
sealed class PracticeStep {
  const PracticeStep();

  /// How long this step occupies. Every step is finite: an open-ended step
  /// cannot be scheduled, cannot be progress-barred, and cannot be logged.
  Duration get duration;

  /// Which limbs this step belongs to. Drives the taxonomy across the app.
  Set<Anga> get angas;
}

/// Measured breathing. [cycles] repetitions of [pattern].
class BreathStep extends PracticeStep {
  const BreathStep({required this.pattern, required this.cycles})
      : assert(cycles > 0);

  final BreathPattern pattern;
  final int cycles;

  @override
  Duration get duration => pattern.cycleDuration * cycles;

  @override
  Set<Anga> get angas => const {Anga.pranayama};

  /// Which cycle we are in, 1-based — practitioners count from one.
  int cycleAt(Duration elapsed) {
    final n = elapsed.inMilliseconds ~/ pattern.cycleDuration.inMilliseconds;
    return (n + 1).clamp(1, cycles);
  }
}

/// Holding a posture. [side] is null for symmetric postures; asymmetric ones
/// are two steps, because the practitioner experiences them as two.
class AsanaStep extends PracticeStep {
  const AsanaStep({
    required this.asanaId,
    required this.hold,
    this.side,
  });

  final String asanaId;
  final Duration hold;
  final BodySide? side;

  @override
  Duration get duration => hold;

  @override
  Set<Anga> get angas => const {Anga.asana};
}

enum BodySide { left, right }

/// Dharana — attention fixed on a single object.
class FocusStep extends PracticeStep {
  const FocusStep({required this.object, required this.duration});

  /// A localization key or a user-authored string. Resolved at the UI edge,
  /// never here: the domain does not know what language anyone speaks.
  final String object;

  @override
  final Duration duration;

  @override
  Set<Anga> get angas => const {Anga.dharana, Anga.pratyahara};
}

/// Dhyana — nothing to do, nothing announced. The hardest step to build
/// because the correct UI is almost no UI.
class SilenceStep extends PracticeStep {
  const SilenceStep({required this.duration});

  @override
  final Duration duration;

  @override
  Set<Anga> get angas => const {Anga.dhyana};
}

/// Svadhyaya — a text read inside the practice, not in the library. This is
/// the hinge between the two halves of the app.
class ReadingStep extends PracticeStep {
  const ReadingStep({
    required this.textId,
    this.duration = const Duration(minutes: 2),
  });

  final String textId;

  @override
  final Duration duration;

  @override
  Set<Anga> get angas => const {Anga.niyama};
}
