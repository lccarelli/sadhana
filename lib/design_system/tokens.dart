import 'package:flutter/material.dart';

/// The palette. Two grounds — pre-dawn indigo and vibhuti ash — and a single
/// verdigris accent. Ember is semantic only: exhalation, and destructive
/// actions. It is never decoration.
abstract final class Palette {
  // Dark — 20:00 to 07:00
  static const darkGround = Color(0xFF131920);
  static const darkSurface = Color(0xFF1B232B);
  static const darkSurface2 = Color(0xFF242E37);
  static const darkInk = Color(0xFFDEE5E7);
  static const darkInk2 = Color(0xFFA5B1B7);
  static const darkMuted = Color(0xFF74818A);
  static const darkRule = Color(0xFF2A343D);
  static const darkAccent = Color(0xFF5CB5A8);
  static const darkAccentSoft = Color(0xFF1B3330);
  static const darkOnAccent = Color(0xFF0B1F1D);
  static const darkEmber = Color(0xFFD4753F);

  // Light — 07:00 to 20:00
  static const lightGround = Color(0xFFE7E9E6);
  static const lightSurface = Color(0xFFF2F3F1);
  static const lightSurface2 = Color(0xFFDBDFDA);
  static const lightInk = Color(0xFF161D22);
  static const lightInk2 = Color(0xFF46525A);
  static const lightMuted = Color(0xFF78838A);
  static const lightRule = Color(0xFFC6CCC6);
  static const lightAccent = Color(0xFF2F7E74);
  static const lightAccentSoft = Color(0xFFD4E5E1);
  static const lightOnAccent = Color(0xFFEAF5F2);
  static const lightEmber = Color(0xFFAC5028);
}

/// Durations derived from breath, not from round numbers.
///
/// One [beat] is 900ms — a quarter of a calm four-count inhale. An app about
/// the breath should not animate at 300ms because 300 is a nice number.
abstract final class Beat {
  static const beat = Duration(milliseconds: 900);
  static const half = Duration(milliseconds: 450);
  static const quarter = Duration(milliseconds: 225);
  static const eighth = Duration(milliseconds: 112);

  static const ease = Curves.easeInOutCubic;
  static const easeOut = Curves.easeOutCubic;
}

abstract final class Space {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 16.0;
  static const lg = 24.0;
  static const xl = 36.0;
  static const screen = 20.0;
}

/// Semantic colours, resolved per theme. Everything in the app reads from
/// here — no widget ever names a Palette constant directly, which is what
/// keeps the two themes honest.
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.ground,
    required this.surface,
    required this.surface2,
    required this.ink,
    required this.ink2,
    required this.muted,
    required this.rule,
    required this.accent,
    required this.accentSoft,
    required this.onAccent,
    required this.ember,
  });

  final Color ground;
  final Color surface;
  final Color surface2;
  final Color ink;
  final Color ink2;
  final Color muted;
  final Color rule;
  final Color accent;
  final Color accentSoft;
  final Color onAccent;
  final Color ember;

  static const dark = AppColors(
    ground: Palette.darkGround,
    surface: Palette.darkSurface,
    surface2: Palette.darkSurface2,
    ink: Palette.darkInk,
    ink2: Palette.darkInk2,
    muted: Palette.darkMuted,
    rule: Palette.darkRule,
    accent: Palette.darkAccent,
    accentSoft: Palette.darkAccentSoft,
    onAccent: Palette.darkOnAccent,
    ember: Palette.darkEmber,
  );

  static const light = AppColors(
    ground: Palette.lightGround,
    surface: Palette.lightSurface,
    surface2: Palette.lightSurface2,
    ink: Palette.lightInk,
    ink2: Palette.lightInk2,
    muted: Palette.lightMuted,
    rule: Palette.lightRule,
    accent: Palette.lightAccent,
    accentSoft: Palette.lightAccentSoft,
    onAccent: Palette.lightOnAccent,
    ember: Palette.lightEmber,
  );

  @override
  AppColors copyWith({
    Color? ground,
    Color? surface,
    Color? surface2,
    Color? ink,
    Color? ink2,
    Color? muted,
    Color? rule,
    Color? accent,
    Color? accentSoft,
    Color? onAccent,
    Color? ember,
  }) =>
      AppColors(
        ground: ground ?? this.ground,
        surface: surface ?? this.surface,
        surface2: surface2 ?? this.surface2,
        ink: ink ?? this.ink,
        ink2: ink2 ?? this.ink2,
        muted: muted ?? this.muted,
        rule: rule ?? this.rule,
        accent: accent ?? this.accent,
        accentSoft: accentSoft ?? this.accentSoft,
        onAccent: onAccent ?? this.onAccent,
        ember: ember ?? this.ember,
      );

  /// Lets the clock-driven theme change cross-fade over a full beat instead
  /// of snapping between palettes.
  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      ground: Color.lerp(ground, other.ground, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surface2: Color.lerp(surface2, other.surface2, t)!,
      ink: Color.lerp(ink, other.ink, t)!,
      ink2: Color.lerp(ink2, other.ink2, t)!,
      muted: Color.lerp(muted, other.muted, t)!,
      rule: Color.lerp(rule, other.rule, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      accentSoft: Color.lerp(accentSoft, other.accentSoft, t)!,
      onAccent: Color.lerp(onAccent, other.onAccent, t)!,
      ember: Color.lerp(ember, other.ember, t)!,
    );
  }
}

extension AppColorsX on BuildContext {
  AppColors get colors => Theme.of(this).extension<AppColors>()!;
}
