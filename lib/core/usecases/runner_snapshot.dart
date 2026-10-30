import '../domain/breath.dart';
import '../domain/practice_step.dart';

enum RunnerStatus { idle, running, paused, completed }

class RunnerSnapshot {
  const RunnerSnapshot({
    required this.status,
    required this.stepIndex,
    required this.step,
    required this.elapsedInStep,
    required this.elapsedTotal,
    required this.sequenceDuration,
    this.breathPhase,
    this.breathRemaining,
    this.breathProgress,
    this.cycle,
    this.totalCycles,
  });

  final RunnerStatus status;
  final int stepIndex;
  final PracticeStep step;
  final Duration elapsedInStep;
  final Duration elapsedTotal;
  final Duration sequenceDuration;

  final BreathPhase? breathPhase;
  final int? breathRemaining;
  final double? breathProgress;
  final int? cycle;
  final int? totalCycles;

  Duration get remainingInStep => step.duration - elapsedInStep;

  double get stepProgress => step.duration.inMilliseconds == 0
      ? 1
      : elapsedInStep.inMilliseconds / step.duration.inMilliseconds;

  bool get isBreathing => breathPhase != null;
}
