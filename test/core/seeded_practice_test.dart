import 'package:flutter_test/flutter_test.dart';
import 'package:sadhana/core/domain/practice_sequence.dart';
import 'package:sadhana/core/usecases/session_runner.dart';

void main() {
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
