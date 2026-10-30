import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sadhana/design_system/theme_controller.dart';

import '../support/clock.dart';

void main() {
  group('ClockThemeResolver', () {
    test('is dark before the light boundary', () {
      for (final hour in [0, 3, 5, 6]) {
        expect(
          resolver.brightnessAt(at(hour)),
          Brightness.dark,
          reason: '$hour:00 should be dark — dawn practice happens here',
        );
      }
    });

    test('is light through the day', () {
      for (final hour in [7, 12, 19]) {
        expect(
          resolver.brightnessAt(at(hour)),
          Brightness.light,
          reason: '$hour:00 should be light',
        );
      }
    });

    test('is dark from 20:00', () {
      for (final hour in [20, 22, 23]) {
        expect(
          resolver.brightnessAt(at(hour)),
          Brightness.dark,
          reason: '$hour:00 should be dark',
        );
      }
    });

    test('flips exactly on the boundary, not a minute early or late', () {
      expect(resolver.brightnessAt(at(6, 59)), Brightness.dark);
      expect(resolver.brightnessAt(at(7)), Brightness.light);
      expect(resolver.brightnessAt(at(19, 59)), Brightness.light);
      expect(resolver.brightnessAt(at(20)), Brightness.dark);
    });

    test('finds the next boundary so one timer replaces polling', () {
      expect(resolver.nextBoundaryAfter(at(3)), at(7));
      expect(resolver.nextBoundaryAfter(at(12)), at(20));
      expect(
        resolver.nextBoundaryAfter(at(22)),
        at(7).add(const Duration(days: 1)),
      );
    });

    test('untilNextBoundary never returns a negative wait', () {
      for (var hour = 0; hour < 24; hour++) {
        expect(
          resolver.untilNextBoundary(at(hour)).isNegative,
          isFalse,
          reason: 'a negative wait at $hour:00 would fire the timer instantly',
        );
      }
    });

    test('honours custom boundaries, for tying to real sunrise later', () {
      const early = ClockThemeResolver(lightStartHour: 5, darkStartHour: 18);
      expect(early.brightnessAt(at(6)), Brightness.light);
      expect(early.brightnessAt(at(19)), Brightness.dark);
    });
  });
}
