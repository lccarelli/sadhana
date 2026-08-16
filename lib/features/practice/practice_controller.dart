import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../../core/domain/breath.dart';
import '../../core/domain/practice_sequence.dart';
import '../../core/domain/practice_step.dart';
import '../../core/usecases/session_runner.dart';
import '../../data/sadhana/practice_recorder.dart';
import '../../design_system/theme_controller.dart';

/// Wraps the pure [SessionRunner] with the things a screen needs and the
/// domain must not know about: haptics, freezing the clock-driven theme, and
/// writing the practice down as it happens.
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

  /// Available once the practice has been closed — the journal entry attaches
  /// to it.
  int? get sessionId => recorder.sessionId;

  Future<void> start() async {
    // Rule 1 of the clock theme: it never changes mid-practice.
    theme.hold();

    // The row exists from the first breath, not from a clean finish, because
    // most practices never get a clean finish.
    await recorder.begin(sequence);

    runner.start();
    _lastPhase = runner.snapshot.breathPhase;
    _noteIfReading(runner.snapshot.step);
    notifyListeners();
  }

  /// Called once per frame with the elapsed delta.
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

    // Throttled inside the recorder: a no-op on all but one frame in 30s.
    // Not awaited — a frame callback must not block on disk.
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

  /// The app is going to the background. Pause rather than end: being
  /// interrupted is not the same as giving up, and coming back to a practice
  /// exactly where you left it is the forgiving behaviour.
  ///
  /// The session stays open on purpose. If the OS kills us from here,
  /// `closeAbandonedSessions` finalises it on next launch with the seconds
  /// this very checkpoint just wrote — which is why the checkpoint is forced.
  void pauseForBackground() {
    runner.pause();
    unawaited(recorder.checkpoint(runner.snapshot.elapsedTotal, force: true));
    notifyListeners();
  }

  /// Close the session. Idempotent, and called from three places — completion,
  /// backgrounding, and disposal — because a practice can end in any of them.
  Future<int?> finish() => recorder.end(
        practised: runner.snapshot.elapsedTotal,
        completed: runner.status == RunnerStatus.completed,
      );

  /// A text met inside a practice, which is what "Practiced ×3" counts. This
  /// is the only real bridge between the two halves of the app.
  void _noteIfReading(PracticeStep step) {
    if (step is ReadingStep) unawaited(recorder.noteTextEncounter(step.textId));
  }

  /// Distinct pulse per phase, so the whole practice can be followed with the
  /// eyes closed and the screen dark. The animation is never load-bearing.
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
    // Last resort: leaving by any route still closes the session honestly.
    unawaited(finish());
    // Rule 1, the other half: catch up with the clock on the way out.
    theme.release();
    super.dispose();
  }
}
