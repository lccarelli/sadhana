import 'package:flutter_test/flutter_test.dart';
import 'package:sadhana/core/domain/breath.dart';
import 'package:sadhana/core/domain/practice_step.dart';
import 'package:sadhana/core/usecases/session_runner.dart';

import '../support/tiny_sequence.dart';

void main() {
  group('SessionRunner', () {
    test('does not advance until started', () {
      final runner = SessionRunner(tiny());
      runner.advance(const Duration(seconds: 10));

      expect(runner.status, RunnerStatus.idle);
      expect(runner.snapshot.elapsedInStep, Duration.zero);
    });

    test('walks the breath phases in order', () {
      final runner = SessionRunner(tiny())..start();

      expect(runner.snapshot.breathPhase, BreathPhase.inhale);
      expect(runner.snapshot.breathRemaining, 2);

      runner.advance(const Duration(seconds: 1));
      expect(runner.snapshot.breathPhase, BreathPhase.inhale);
      expect(runner.snapshot.breathRemaining, 1);

      runner.advance(const Duration(seconds: 1));
      expect(runner.snapshot.breathPhase, BreathPhase.exhale);
      expect(runner.snapshot.breathRemaining, 2);
    });

    test('counts cycles from one, the way a practitioner does', () {
      final runner = SessionRunner(tiny())..start();
      expect(runner.snapshot.cycle, 1);

      runner.advance(const Duration(seconds: 4));
      expect(runner.snapshot.cycle, 2);
    });

    test('crosses into the next step when a step runs out', () {
      final runner = SessionRunner(tiny())..start();

      runner.advance(const Duration(seconds: 8));

      expect(runner.stepIndex, 1);
      expect(runner.snapshot.step, isA<SilenceStep>());
      expect(runner.snapshot.isBreathing, isFalse);
    });

    test('carries a delta that spans several steps', () {
      final runner = SessionRunner(tiny())..start();
      runner.advance(const Duration(seconds: 14));

      expect(runner.stepIndex, 2);
      expect(runner.snapshot.elapsedInStep, const Duration(seconds: 1));
    });

    test('completes at the end and stops accepting time', () {
      final runner = SessionRunner(tiny())..start();
      runner.advance(const Duration(seconds: 16));

      expect(runner.status, RunnerStatus.completed);

      runner.advance(const Duration(seconds: 60));
      expect(runner.status, RunnerStatus.completed);
      expect(runner.stepIndex, 2);
    });

    test('pause freezes time, resume unfreezes it', () {
      final runner = SessionRunner(tiny())..start();
      runner.advance(const Duration(seconds: 1));
      runner.pause();

      runner.advance(const Duration(seconds: 30));
      expect(runner.snapshot.elapsedInStep, const Duration(seconds: 1));

      runner.resume();
      runner.advance(const Duration(seconds: 1));
      expect(runner.snapshot.elapsedInStep, const Duration(seconds: 2));
    });

    test('skip jumps to the next step', () {
      final runner = SessionRunner(tiny())..start();
      runner.skip();

      expect(runner.stepIndex, 1);
      expect(runner.snapshot.elapsedInStep, Duration.zero);
    });

    test('back restarts the step, then steps back once inside the window', () {
      final runner = SessionRunner(tiny())..start();
      runner.skip();
      runner.advance(const Duration(seconds: 4));

      runner.back();
      expect(runner.stepIndex, 1);
      expect(runner.snapshot.elapsedInStep, Duration.zero);

      runner.back();
      expect(runner.stepIndex, 0);
    });

    test('elapsedTotal accumulates across steps', () {
      final runner = SessionRunner(tiny())..start();
      runner.advance(const Duration(seconds: 10));

      expect(runner.snapshot.elapsedTotal, const Duration(seconds: 10));
      expect(runner.snapshot.sequenceDuration, const Duration(seconds: 16));
    });
  });
}
