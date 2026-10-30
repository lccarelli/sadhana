import '../domain/practice_sequence.dart';
import '../domain/practice_step.dart';
import 'runner_snapshot.dart';

export 'runner_snapshot.dart';

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

  void togglePause() => _status == RunnerStatus.running ? pause() : resume();

  void skip() {
    if (_status == RunnerStatus.completed) return;
    _enterStep(_stepIndex + 1);
  }

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
