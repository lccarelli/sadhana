/// The four phases of a measured breath. Order matters: a cycle always runs
/// inhale → holdIn → exhale → holdOut, and phases of zero length are skipped
/// rather than rendered as an instant flash.
enum BreathPhase { inhale, holdIn, exhale, holdOut }

/// A breath ratio, in seconds per phase. 4:4:8:0 is nadi shodhana as taught
/// most commonly; 4:0:4:0 is sama vritti; 4:7:8:0 is the relaxing pattern.
class BreathPattern {
  const BreathPattern({
    required this.inhale,
    this.holdIn = 0,
    required this.exhale,
    this.holdOut = 0,
  })  : assert(inhale > 0, 'a breath must have an inhale'),
        assert(exhale > 0, 'a breath must have an exhale'),
        assert(holdIn >= 0),
        assert(holdOut >= 0);

  final int inhale;
  final int holdIn;
  final int exhale;
  final int holdOut;

  static const nadiShodhana = BreathPattern(inhale: 4, holdIn: 4, exhale: 8);
  static const samaVritti = BreathPattern(inhale: 4, exhale: 4);
  static const calming = BreathPattern(inhale: 4, holdIn: 7, exhale: 8);

  Duration get cycleDuration =>
      Duration(seconds: inhale + holdIn + exhale + holdOut);

  int secondsOf(BreathPhase phase) => switch (phase) {
        BreathPhase.inhale => inhale,
        BreathPhase.holdIn => holdIn,
        BreathPhase.exhale => exhale,
        BreathPhase.holdOut => holdOut,
      };

  /// Phases that actually occupy time, in cycle order.
  List<BreathPhase> get activePhases =>
      BreathPhase.values.where((p) => secondsOf(p) > 0).toList();

  /// Where we are inside one cycle. [offset] must be < [cycleDuration].
  ///
  /// Returns the phase and how much of it is left, counted the way a
  /// practitioner counts: 4, 3, 2, 1 — never 0.
  ({BreathPhase phase, int remaining, double progress}) phaseAt(
    Duration offset,
  ) {
    var elapsed = offset.inMilliseconds;
    final cycleMs = cycleDuration.inMilliseconds;
    elapsed = elapsed % cycleMs;

    for (final phase in activePhases) {
      final phaseMs = secondsOf(phase) * 1000;
      if (elapsed < phaseMs) {
        return (
          phase: phase,
          remaining: ((phaseMs - elapsed) / 1000).ceil(),
          progress: elapsed / phaseMs,
        );
      }
      elapsed -= phaseMs;
    }

    // Unreachable: activePhases always sum to cycleMs.
    final last = activePhases.last;
    return (phase: last, remaining: 1, progress: 1.0);
  }

  /// "4 : 4 : 8" — rendered in mono, identical in every language.
  String get label => [
        inhale,
        if (holdIn > 0) holdIn,
        exhale,
        if (holdOut > 0) holdOut,
      ].join(' : ');

  @override
  bool operator ==(Object other) =>
      other is BreathPattern &&
      other.inhale == inhale &&
      other.holdIn == holdIn &&
      other.exhale == exhale &&
      other.holdOut == holdOut;

  @override
  int get hashCode => Object.hash(inhale, holdIn, exhale, holdOut);
}
