import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../../core/domain/breath.dart';
import '../../core/domain/practice_sequence.dart';
import '../../core/domain/practice_step.dart';
import '../../core/usecases/session_runner.dart';
import '../../data/sadhana/practice_recorder.dart';
import '../../design_system/theme_controller.dart';

class PracticeController extends ChangeNotifier {
  PracticeController({
    required this.sequence,
    required this.theme,
    required this.recorder,
  }) : runner = SessionRunner(sequence);

  final PracticeSequence sequence;
  final ThemeController theme;
  final PracticeRecorder recorder;
  final SessionRunner runner;

  BreathPhase? _lastPhase;
  int _lastStepIndex = 0;

  RunnerSnapshot get snapshot => runner.snapshot;

  int? get sessionId => recorder.sessionId;

  Future<void> start() async {
    theme.hold();

    await recorder.begin(sequence);

    runner.start();
    _lastPhase = runner.snapshot.breathPhase;
    _noteIfReading(runner.snapshot.step);
    notifyListeners();
  }

  void advance(Duration delta) {
    if (runner.status != RunnerStatus.running) return;
    runner.advance(delta);

    final snap = runner.snapshot;

    if (snap.breathPhase != _lastPhase) {
      _lastPhase = snap.breathPhase;
      if (snap.breathPhase != null) _pulse(snap.breathPhase!);
    }
    if (snap.stepIndex != _lastStepIndex) {
      _lastStepIndex = snap.stepIndex;
      HapticFeedback.mediumImpact();
      _noteIfReading(snap.step);
    }

    unawaited(recorder.checkpoint(snap.elapsedTotal));

    if (snap.status == RunnerStatus.completed) unawaited(finish());

    notifyListeners();
  }

  void togglePause() {
    runner.togglePause();
    notifyListeners();
  }

  void skip() {
    runner.skip();
    _noteIfReading(runner.snapshot.step);
    if (runner.status == RunnerStatus.completed) unawaited(finish());
    notifyListeners();
  }

  void back() {
    runner.back();
    notifyListeners();
  }

  void pauseForBackground() {
    runner.pause();
    unawaited(recorder.checkpoint(runner.snapshot.elapsedTotal, force: true));
    notifyListeners();
  }

  Future<int?> finish() => recorder.end(
    practised: runner.snapshot.elapsedTotal,
    completed: runner.status == RunnerStatus.completed,
  );

  void _noteIfReading(PracticeStep step) {
    if (step is ReadingStep) unawaited(recorder.noteTextEncounter(step.textId));
  }

  void _pulse(BreathPhase phase) {
    switch (phase) {
      case BreathPhase.inhale:
        HapticFeedback.lightImpact();
      case BreathPhase.holdIn:
      case BreathPhase.holdOut:
        HapticFeedback.selectionClick();
      case BreathPhase.exhale:
        HapticFeedback.mediumImpact();
    }
  }

  @override
  void dispose() {
    unawaited(finish());
    theme.release();
    super.dispose();
  }
}
