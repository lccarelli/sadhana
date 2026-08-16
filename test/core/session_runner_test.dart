import 'package:flutter_test/flutter_test.dart';
import 'package:sadhana/core/domain/breath.dart';
import 'package:sadhana/core/domain/practice_sequence.dart';
import 'package:sadhana/core/domain/practice_step.dart';
import 'package:sadhana/core/usecases/session_runner.dart';

/// A twenty-four minute practice, tested in microseconds. This is the whole
/// payoff of the runner owning no Timer and never reading the clock.
void main() {
  PracticeSequence tiny() => PracticeSequence(
        id: 'test.tiny',
        title: 'tiny',
        steps: const [
          BreathStep(pattern: BreathPattern(inhale: 2, exhale: 2), cycles: 2),
          SilenceStep(duration: Duration(seconds: 5)),
          AsanaStep(
            asanaId: 'asana.trikonasana',
            hold: Duration(seconds: 3),
            side: BodySide.right,
          ),
        ],
      );

  group('SessionRunner', () {
    test('does not advance until started', () {
      final runner = SessionRunner(tiny());
      runner.advance(const Duration(seconds: 10));

      expect(runner.status, RunnerStatus.idle);
      expect(runner.snapshot.elapsedInStep, Duration.zero);
    });

    test('walks the breath phases in order', () {
      final runner = SessionRunner(tiny())..start();

      // 2:2, so the first two seconds inhale and the next two exhale.
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

      // Breath step is 2 cycles × 4s = 8s.
      runner.advance(const Duration(seconds: 8));

      expect(runner.stepIndex, 1);
      expect(runner.snapshot.step, isA<SilenceStep>());
      expect(runner.snapshot.isBreathing, isFalse);
    });

    test('carries a delta that spans several steps', () {
      // The app may have been backgrounded. The domain stays correct; whether
      // fast-forwarding is *desirable* is the app layer's call.
      final runner = SessionRunner(tiny())..start();
      runner.advance(const Duration(seconds: 14)); // 8 + 5 + 1

      expect(runner.stepIndex, 2);
      expect(runner.snapshot.elapsedInStep, const Duration(seconds: 1));
    });

    test('completes at the end and stops accepting time', () {
      final runner = SessionRunner(tiny())..start();
      runner.advance(const Duration(seconds: 16)); // total is 8 + 5 + 3

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
      runner.skip(); // now on step 1
      runner.advance(const Duration(seconds: 4));

      runner.back(); // 4s in, past the restart window → restart step 1
      expect(runner.stepIndex, 1);
      expect(runner.snapshot.elapsedInStep, Duration.zero);

      runner.back(); // 0s in → step back to 0
      expect(runner.stepIndex, 0);
    });

    test('elapsedTotal accumulates across steps', () {
      final runner = SessionRunner(tiny())..start();
      runner.advance(const Duration(seconds: 10)); // 8 into step 1, +2

      expect(runner.snapshot.elapsedTotal, const Duration(seconds: 10));
      expect(runner.snapshot.sequenceDuration, const Duration(seconds: 16));
    });
  });

  group('the seeded practice', () {
    test('is 24 minutes, as the Today card claims', () {
      expect(PracticeSequence.slowMorning.duration.inMinutes, 24);
    });

    test('reaches the inner limbs', () {
      final angas = PracticeSequence.slowMorning.angas;
      expect(angas.any((a) => a.isInner), isTrue);
    });

    test('runs end to end without throwing', () {
      final sequence = PracticeSequence.slowMorning;
      final runner = SessionRunner(sequence)..start();

      // One second at a time, the way it actually happens.
      for (var i = 0; i < sequence.duration.inSeconds; i++) {
        runner.advance(const Duration(seconds: 1));
      }
      expect(runner.status, RunnerStatus.completed);
    });

    test('has six steps, as the Today card claims', () {
      expect(PracticeSequence.slowMorning.steps.length, 6);
    });
  });
}
