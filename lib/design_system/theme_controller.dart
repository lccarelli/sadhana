import 'dart:async';

import 'package:flutter/widgets.dart';

enum AppThemeMode { auto, light, dark }

@immutable
class ClockThemeResolver {
  const ClockThemeResolver({this.lightStartHour = 7, this.darkStartHour = 20})
    : assert(lightStartHour >= 0 && lightStartHour < 24),
      assert(darkStartHour > lightStartHour && darkStartHour < 24);

  final int lightStartHour;
  final int darkStartHour;

  Brightness brightnessAt(DateTime t) =>
      t.hour >= lightStartHour && t.hour < darkStartHour
      ? Brightness.light
      : Brightness.dark;

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

class ThemeController extends ChangeNotifier with WidgetsBindingObserver {
  ThemeController({
    this.resolver = const ClockThemeResolver(),
    AppThemeMode mode = AppThemeMode.auto,
    DateTime Function()? now,
  }) : _mode = mode,
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

  void hold() => _held = true;

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
    if (_held && !force) return;
    final next = _resolve();
    if (next == _brightness) return;
    _brightness = next;
    notifyListeners();
  }

  void _schedule() {
    _timer?.cancel();
    if (_mode != AppThemeMode.auto) return;
    final wait =
        resolver.untilNextBoundary(_now()) + const Duration(seconds: 1);
    _timer = Timer(wait, () {
      _apply();
      _schedule();
    });
  }

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
