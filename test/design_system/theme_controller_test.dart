import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sadhana/design_system/theme_controller.dart';

void main() {
  // ThemeController schedules a real Timer to the next boundary, so these run
  // as plain tests against a real binding rather than inside testWidgets'
  // FakeAsync — which would flag that timer as leaked.
  TestWidgetsFlutterBinding.ensureInitialized();

  const resolver = ClockThemeResolver(); // light 07:00, dark 20:00
  DateTime at(int hour, [int minute = 0]) =>
      DateTime(2026, 8, 15, hour, minute);

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
        expect(resolver.brightnessAt(at(hour)), Brightness.light,
            reason: '$hour:00 should be light');
      }
    });

    test('is dark from 20:00', () {
      for (final hour in [20, 22, 23]) {
        expect(resolver.brightnessAt(at(hour)), Brightness.dark,
            reason: '$hour:00 should be dark');
      }
    });

    test('flips exactly on the boundary, not a minute early or late', () {
      expect(resolver.brightnessAt(at(6, 59)), Brightness.dark);
      expect(resolver.brightnessAt(at(7, 0)), Brightness.light);
      expect(resolver.brightnessAt(at(19, 59)), Brightness.light);
      expect(resolver.brightnessAt(at(20, 0)), Brightness.dark);
    });

    test('finds the next boundary so one timer replaces polling', () {
      expect(resolver.nextBoundaryAfter(at(3)), at(7));
      expect(resolver.nextBoundaryAfter(at(12)), at(20));
      // After the last boundary of the day, wrap to tomorrow morning.
      expect(resolver.nextBoundaryAfter(at(22)), at(7).add(const Duration(days: 1)));
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

  group('ThemeController', () {
    test('follows the clock in auto mode', () async {
      final controller = ThemeController(now: () => DateTime(2026, 8, 15, 21));
      addTearDown(controller.dispose);

      expect(controller.brightness, Brightness.dark);
    });

    test('an explicit choice overrides the clock', () async {
      final controller = ThemeController(now: () => DateTime(2026, 8, 15, 21));
      addTearDown(controller.dispose);

      controller.mode = AppThemeMode.light;
      expect(controller.brightness, Brightness.light);
    });

    test('never changes while held — no flash mid-savasana', () async {
      var clock = DateTime(2026, 8, 15, 19, 55);
      final controller = ThemeController(now: () => clock);
      addTearDown(controller.dispose);

      expect(controller.brightness, Brightness.light);

      controller.hold();
      clock = DateTime(2026, 8, 15, 20, 5); // boundary passed mid-practice

      var notified = 0;
      controller.addListener(() => notified++);
      controller.didChangeAppLifecycleState(AppLifecycleState.resumed);

      expect(controller.brightness, Brightness.light,
          reason: 'held themes must not change during a practice');
      expect(notified, 0);

      controller.release();
      expect(controller.brightness, Brightness.dark,
          reason: 'and must catch up the moment the practice ends');
      expect(notified, 1);
    });

    test('catches up after the app slept across a boundary', () async {
      var clock = DateTime(2026, 8, 15, 18);
      final controller = ThemeController(now: () => clock);
      addTearDown(controller.dispose);

      expect(controller.brightness, Brightness.light);

      // Timers do not fire reliably in the background.
      clock = DateTime(2026, 8, 16, 2);
      controller.didChangeAppLifecycleState(AppLifecycleState.resumed);

      expect(controller.brightness, Brightness.dark);
    });
  });
}
