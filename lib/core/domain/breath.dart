enum BreathPhase { inhale, holdIn, exhale, holdOut }

class BreathPattern {
  const BreathPattern({
    required this.inhale,
    this.holdIn = 0,
    required this.exhale,
    this.holdOut = 0,
  }) : assert(inhale > 0, 'a breath must have an inhale'),
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

  BreathPattern withPhase(BreathPhase phase, int seconds) => BreathPattern(
    inhale: phase == BreathPhase.inhale ? seconds : inhale,
    holdIn: phase == BreathPhase.holdIn ? seconds : holdIn,
    exhale: phase == BreathPhase.exhale ? seconds : exhale,
    holdOut: phase == BreathPhase.holdOut ? seconds : holdOut,
  );

  Duration get cycleDuration =>
      Duration(seconds: inhale + holdIn + exhale + holdOut);

  int secondsOf(BreathPhase phase) => switch (phase) {
    BreathPhase.inhale => inhale,
    BreathPhase.holdIn => holdIn,
    BreathPhase.exhale => exhale,
    BreathPhase.holdOut => holdOut,
  };

  List<BreathPhase> get activePhases =>
      BreathPhase.values.where((p) => secondsOf(p) > 0).toList();

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

    final last = activePhases.last;
    return (phase: last, remaining: 1, progress: 1.0);
  }

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
