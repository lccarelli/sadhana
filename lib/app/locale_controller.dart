import 'package:flutter/widgets.dart';

class LocaleController extends ChangeNotifier {
  LocaleController([this._locale]);

  static const supported = <Locale>[Locale('en'), Locale('es')];

  Locale? _locale;

  Locale? get locale => _locale;

  String effectiveCode(Locale deviceLocale) {
    if (_locale != null) return _locale!.languageCode;
    final match = supported.where(
      (l) => l.languageCode == deviceLocale.languageCode,
    );
    return match.isEmpty
        ? supported.first.languageCode
        : match.first.languageCode;
  }

  void set(Locale? value) {
    if (_locale == value) return;
    _locale = value;
    notifyListeners();
  }
}
