import 'package:flutter_test/flutter_test.dart';
import 'package:sadhana/core/domain/breath.dart';

void main() {
  group('BreathPattern', () {
    const nadi = BreathPattern.nadiShodhana;

    test('cycle is the sum of its phases', () {
      expect(nadi.cycleDuration, const Duration(seconds: 16));
    });

    test('skips zero-length phases instead of flashing through them', () {
      const sama = BreathPattern.samaVritti;
      expect(sama.activePhases, [BreathPhase.inhale, BreathPhase.exhale]);
    });

    test('finds the phase at any offset in the cycle', () {
      expect(nadi.phaseAt(Duration.zero).phase, BreathPhase.inhale);
      expect(
        nadi.phaseAt(const Duration(seconds: 3)).phase,
        BreathPhase.inhale,
      );
      expect(
        nadi.phaseAt(const Duration(seconds: 4)).phase,
        BreathPhase.holdIn,
      );
      expect(
        nadi.phaseAt(const Duration(seconds: 8)).phase,
        BreathPhase.exhale,
      );
      expect(
        nadi.phaseAt(const Duration(seconds: 15, milliseconds: 999)).phase,
        BreathPhase.exhale,
      );
    });

    test('wraps into the next cycle', () {
      expect(
        nadi.phaseAt(const Duration(seconds: 16)).phase,
        BreathPhase.inhale,
      );
      expect(
        nadi.phaseAt(const Duration(seconds: 20)).phase,
        BreathPhase.holdIn,
      );
    });

    test('counts down the way a practitioner counts — never zero', () {
      expect(nadi.phaseAt(Duration.zero).remaining, 4);
      expect(nadi.phaseAt(const Duration(milliseconds: 500)).remaining, 4);
      expect(nadi.phaseAt(const Duration(seconds: 1)).remaining, 3);
      expect(nadi.phaseAt(const Duration(seconds: 3)).remaining, 1);
      expect(
        nadi.phaseAt(const Duration(seconds: 3, milliseconds: 999)).remaining,
        1,
      );
    });

    test('progress runs 0 to 1 within a phase', () {
      expect(nadi.phaseAt(Duration.zero).progress, 0);
      expect(
        nadi.phaseAt(const Duration(seconds: 2)).progress,
        closeTo(0.5, 1e-9),
      );
    });

    test('label renders holds only when they exist', () {
      expect(BreathPattern.nadiShodhana.label, '4 : 4 : 8');
      expect(BreathPattern.samaVritti.label, '4 : 4');
      expect(BreathPattern.calming.label, '4 : 7 : 8');
    });

    test('changes one phase and keeps the rest', () {
      final changed = BreathPattern.nadiShodhana.withPhase(
        BreathPhase.holdOut,
        2,
      );

      expect(changed.inhale, 4);
      expect(changed.holdIn, 4);
      expect(changed.exhale, 8);
      expect(changed.holdOut, 2);
    });
  });
}
