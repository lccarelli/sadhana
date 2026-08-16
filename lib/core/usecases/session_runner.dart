import '../domain/breath.dart';
import '../domain/practice_sequence.dart';
import '../domain/practice_step.dart';

enum RunnerStatus { idle, running, paused, completed }

/// Everything the practice screen needs to draw one frame. Immutable, so the
/// UI can compare snapshots instead of guessing what changed.
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

  /// Populated only while a [BreathStep] is running.
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

/// Interprets a [PracticeSequence].
///
/// Deliberately owns no `Timer` and never reads the clock. Time is pushed in
/// from outside via [advance], which makes the whole thing deterministic:
/// a twenty-four minute practice is one test that runs in microseconds, with
/// no emulator and no fake async.
class SessionRunner {
  SessionRunner(this.sequence);

  final PracticeSequence sequence;

  int _stepIndex = 0;
  Duration _elapsedInStep = Duration.zero;
  RunnerStatus _status = RunnerStatus.idle;

  RunnerStatus get status => _status;
  int get stepIndex => _stepIndex;

  void start() {
    if (_status == RunnerStatus.idle) _status = RunnerStatus.running;
  }

  void pause() {
    if (_status == RunnerStatus.running) _status = RunnerStatus.paused;
  }

  void resume() {
    if (_status == RunnerStatus.paused) _status = RunnerStatus.running;
  }

  /// Tap anywhere toggles. The practice screen has no small controls.
  void togglePause() =>
      _status == RunnerStatus.running ? pause() : resume();

  /// Skip to the next step. Completing past the last step ends the practice.
  void skip() {
    if (_status == RunnerStatus.completed) return;
    _enterStep(_stepIndex + 1);
  }

  /// Back to the start of this step, or to the previous one if we only just
  /// entered this one — the behaviour every media player has trained people
  /// to expect.
  void back({Duration restartWindow = const Duration(seconds: 3)}) {
    if (_status == RunnerStatus.completed) {
      _status = RunnerStatus.running;
    }
    if (_elapsedInStep > restartWindow || _stepIndex == 0) {
      _elapsedInStep = Duration.zero;
    } else {
      _enterStep(_stepIndex - 1);
    }
  }

  /// Push time in. Handles a [delta] that spans several steps, because the
  /// app may have been backgrounded — whether *fast-forwarding* through a
  /// long absence is desirable is a policy question for the app layer, which
  /// can clamp [delta] or pause on resume. The domain just stays correct.
  void advance(Duration delta) {
    if (_status != RunnerStatus.running) return;
    assert(!delta.isNegative, 'time does not run backwards');

    var remaining = delta;
    while (remaining > Duration.zero) {
      final left = sequence.steps[_stepIndex].duration - _elapsedInStep;
      if (remaining < left) {
        _elapsedInStep += remaining;
        return;
      }
      remaining -= left;
      _enterStep(_stepIndex + 1);
      if (_status == RunnerStatus.completed) return;
    }
  }

  void _enterStep(int index) {
    if (index >= sequence.steps.length) {
      _stepIndex = sequence.steps.length - 1;
      _elapsedInStep = sequence.steps[_stepIndex].duration;
      _status = RunnerStatus.completed;
      return;
    }
    _stepIndex = index.clamp(0, sequence.steps.length - 1);
    _elapsedInStep = Duration.zero;
  }

  RunnerSnapshot get snapshot {
    final step = sequence.steps[_stepIndex];
    final base = RunnerSnapshot(
      status: _status,
      stepIndex: _stepIndex,
      step: step,
      elapsedInStep: _elapsedInStep,
      elapsedTotal: sequence.offsetOf(_stepIndex) + _elapsedInStep,
      sequenceDuration: sequence.duration,
    );

    if (step is! BreathStep) return base;

    final phase = step.pattern.phaseAt(_elapsedInStep);
    return RunnerSnapshot(
      status: base.status,
      stepIndex: base.stepIndex,
      step: base.step,
      elapsedInStep: base.elapsedInStep,
      elapsedTotal: base.elapsedTotal,
      sequenceDuration: base.sequenceDuration,
      breathPhase: phase.phase,
      breathRemaining: phase.remaining,
      breathProgress: phase.progress,
      cycle: step.cycleAt(_elapsedInStep),
      totalCycles: step.cycles,
    );
  }
}
