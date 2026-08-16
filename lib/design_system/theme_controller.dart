import 'dart:async';

import 'package:flutter/widgets.dart';

/// What the user picked in Settings. [auto] follows the clock; the other two
/// are an override. The override is an accessibility requirement, not a
/// preference — some people cannot use a light screen at any hour.
enum AppThemeMode { auto, light, dark }

/// The clock rule, as pure logic so it can be tested at every hour of the day
/// without waiting for any of them.
///
/// Light from [lightStartHour] to [darkStartHour], dark otherwise. The hours
/// are fields rather than constants so that tying them to real sunrise by
/// geolocation later changes only where the two numbers come from.
@immutable
class ClockThemeResolver {
  const ClockThemeResolver({
    this.lightStartHour = 7,
    this.darkStartHour = 20,
  })  : assert(lightStartHour >= 0 && lightStartHour < 24),
        assert(darkStartHour > lightStartHour && darkStartHour < 24);

  final int lightStartHour;
  final int darkStartHour;

  Brightness brightnessAt(DateTime t) =>
      t.hour >= lightStartHour && t.hour < darkStartHour
          ? Brightness.light
          : Brightness.dark;

  /// The next instant the theme flips. Used to schedule a single timer
  /// instead of polling the clock every minute.
  DateTime nextBoundaryAfter(DateTime t) {
    final today = DateTime(t.year, t.month, t.day);
    final toLight = today.add(Duration(hours: lightStartHour));
    final toDark = today.add(Duration(hours: darkStartHour));

    if (t.isBefore(toLight)) return toLight;
    if (t.isBefore(toDark)) return toDark;
    return toLight.add(const Duration(days: 1));
  }

  Duration untilNextBoundary(DateTime t) => nextBoundaryAfter(t).difference(t);
}

/// Drives the app's brightness from the clock.
///
/// Three rules make this bearable rather than annoying:
///   1. It never changes during a practice — see [hold] / [release]. A flash
///      from white to black during savasana is unforgivable.
///   2. The change cross-fades over a full beat (handled by AppColors.lerp).
///   3. The user can always force it (AppThemeMode.light / .dark).
class ThemeController extends ChangeNotifier with WidgetsBindingObserver {
  ThemeController({
    this.resolver = const ClockThemeResolver(),
    AppThemeMode mode = AppThemeMode.auto,
    DateTime Function()? now,
  })  : _mode = mode,
        _now = now ?? DateTime.now {
    _brightness = _resolve();
    WidgetsBinding.instance.addObserver(this);
    _schedule();
  }

  final ClockThemeResolver resolver;
  final DateTime Function() _now;

  AppThemeMode _mode;
  late Brightness _brightness;
  Timer? _timer;
  bool _held = false;

  AppThemeMode get mode => _mode;
  Brightness get brightness => _brightness;

  set mode(AppThemeMode value) {
    if (_mode == value) return;
    _mode = value;
    _apply(force: true);
    _schedule();
  }

  /// Freeze the theme for the duration of a practice.
  void hold() => _held = true;

  /// Unfreeze, and catch up if a boundary passed while we were practising.
  void release() {
    _held = false;
    _apply();
    _schedule();
  }

  Brightness _resolve() => switch (_mode) {
        AppThemeMode.light => Brightness.light,
        AppThemeMode.dark => Brightness.dark,
        AppThemeMode.auto => resolver.brightnessAt(_now()),
      };

  void _apply({bool force = false}) {
    // A held theme still recomputes on release; it just does not notify now.
    if (_held && !force) return;
    final next = _resolve();
    if (next == _brightness) return;
    _brightness = next;
    notifyListeners();
  }

  void _schedule() {
    _timer?.cancel();
    if (_mode != AppThemeMode.auto) return;
    // One timer to the next boundary, not a poll. Add a second of slack so we
    // land just past the hour rather than exactly on it.
    final wait = resolver.untilNextBoundary(_now()) + const Duration(seconds: 1);
    _timer = Timer(wait, () {
      _apply();
      _schedule();
    });
  }

  /// Timers do not fire reliably in the background: the app may have slept
  /// for eight hours and crossed a boundary. Recompute on the way back.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _apply();
      _schedule();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
