import 'package:flutter/services.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

abstract final class PracticeFocusMode {
  static Future<void> enter() async {
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    await WakelockPlus.enable();
  }

  static Future<void> exit() async {
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    await WakelockPlus.disable();
  }
}
