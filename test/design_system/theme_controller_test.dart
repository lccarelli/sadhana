import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sadhana/design_system/theme_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

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
      clock = DateTime(2026, 8, 15, 20, 5);

      var notified = 0;
      controller.addListener(() => notified++);
      controller.didChangeAppLifecycleState(AppLifecycleState.resumed);

      expect(
        controller.brightness,
        Brightness.light,
        reason: 'held themes must not change during a practice',
      );
      expect(notified, 0);

      controller.release();
      expect(
        controller.brightness,
        Brightness.dark,
        reason: 'and must catch up the moment the practice ends',
      );
      expect(notified, 1);
    });

    test('catches up after the app slept across a boundary', () async {
      var clock = DateTime(2026, 8, 15, 18);
      final controller = ThemeController(now: () => clock);
      addTearDown(controller.dispose);

      expect(controller.brightness, Brightness.light);

      clock = DateTime(2026, 8, 16, 2);
      controller.didChangeAppLifecycleState(AppLifecycleState.resumed);

      expect(controller.brightness, Brightness.dark);
    });
  });
}
