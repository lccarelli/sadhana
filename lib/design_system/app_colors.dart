import 'package:flutter/material.dart';

import 'tokens.dart';

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
  }) => AppColors(
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
