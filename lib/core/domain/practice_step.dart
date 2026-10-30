import 'anga.dart';
import 'breath.dart';

sealed class PracticeStep {
  const PracticeStep();

  Duration get duration;

  Set<Anga> get angas;
}

class BreathStep extends PracticeStep {
  const BreathStep({required this.pattern, required this.cycles})
    : assert(cycles > 0);

  final BreathPattern pattern;
  final int cycles;

  @override
  Duration get duration => pattern.cycleDuration * cycles;

  @override
  Set<Anga> get angas => const {Anga.pranayama};

  int cycleAt(Duration elapsed) {
    final n = elapsed.inMilliseconds ~/ pattern.cycleDuration.inMilliseconds;
    return (n + 1).clamp(1, cycles);
  }
}

class AsanaStep extends PracticeStep {
  const AsanaStep({required this.asanaId, required this.hold, this.side});

  final String asanaId;
  final Duration hold;
  final BodySide? side;

  @override
  Duration get duration => hold;

  @override
  Set<Anga> get angas => const {Anga.asana};
}

enum BodySide { left, right }

class FocusStep extends PracticeStep {
  const FocusStep({required this.object, required this.duration});

  final String object;

  @override
  final Duration duration;

  @override
  Set<Anga> get angas => const {Anga.dharana, Anga.pratyahara};
}

class SilenceStep extends PracticeStep {
  const SilenceStep({required this.duration});

  @override
  final Duration duration;

  @override
  Set<Anga> get angas => const {Anga.dhyana};
}

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
