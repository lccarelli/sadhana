import 'package:flutter/widgets.dart';

/// Which language the app speaks.
///
/// Adding a language is: drop `app_xx.arb` in lib/l10n, add the Locale to
/// [supported], run `flutter gen-l10n`. Nothing else in the codebase changes.
/// That is the whole point of keeping UI strings out of the widgets.
class LocaleController extends ChangeNotifier {
  LocaleController([this._locale]);

  /// Order matters: the first entry is the fallback when the device language
  /// is one we do not speak.
  static const supported = <Locale>[
    Locale('en'),
    Locale('es'),
  ];

  Locale? _locale;

  /// null means "follow the device". The picker offers an explicit choice
  /// because in an international market the first screen decides whether
  /// someone stays.
  Locale? get locale => _locale;

  /// The language actually in effect, for tagging content and querying the
  /// corpus — never null, unlike [locale].
  String effectiveCode(Locale deviceLocale) {
    if (_locale != null) return _locale!.languageCode;
    final match = supported.where(
      (l) => l.languageCode == deviceLocale.languageCode,
    );
    return match.isEmpty ? supported.first.languageCode : match.first.languageCode;
  }

  void set(Locale? value) {
    if (_locale == value) return;
    _locale = value;
    notifyListeners();
  }
}
