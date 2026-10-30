import 'package:flutter/material.dart';

export 'app_colors.dart';

abstract final class Palette {
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
