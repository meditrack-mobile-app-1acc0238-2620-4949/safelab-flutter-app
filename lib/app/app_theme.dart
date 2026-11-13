import 'package:flutter/material.dart';

abstract final class SafeLabPalette {
  static const primary = Color(0xFF4F35E8);
  static const blue = Color(0xFF1056D9);
  static const teal = Color(0xFF14B8A6);
  static const success = Color(0xFF10B981);
  static const danger = Color(0xFFEF4444);
  static const amber = Color(0xFFF59E0B);
  static const darkBackground = Color(0xFF0F172A);
  static const darkPanel = Color(0xFF17203B);
  static const darkSurface = Color(0xFF111B2F);
  static const lightBackground = Color(0xFFF3F6FE);
}

ThemeData safeLabTheme(bool dark) {
  final scheme = ColorScheme.fromSeed(
    seedColor: SafeLabPalette.primary,
    brightness: dark ? Brightness.dark : Brightness.light,
    surface: dark ? SafeLabPalette.darkBackground : SafeLabPalette.lightBackground,
  );
  final card = dark ? SafeLabPalette.darkPanel : Colors.white;
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: dark ? SafeLabPalette.darkBackground : SafeLabPalette.lightBackground,
    cardColor: card,
    appBarTheme: AppBarTheme(
      backgroundColor: dark ? SafeLabPalette.darkBackground : SafeLabPalette.lightBackground,
      scrolledUnderElevation: 0,
      elevation: 0,
      foregroundColor: dark ? Colors.white : const Color(0xFF111827),
      titleTextStyle: TextStyle(color: dark ? Colors.white : const Color(0xFF111827), fontWeight: FontWeight.w800, fontSize: 19),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: card,
      contentPadding: const EdgeInsets.symmetric(horizontal: 17, vertical: 18),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide(color: dark ? const Color(0xFF788097) : const Color(0xFF8C9099), width: 1.3)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: const BorderSide(color: SafeLabPalette.primary, width: 2)),
    ),
    filledButtonTheme: FilledButtonThemeData(style: FilledButton.styleFrom(
      minimumSize: const Size.fromHeight(54),
      backgroundColor: SafeLabPalette.primary,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)),
      textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    )),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: dark ? const Color(0xFF293556) : const Color(0xFF1E293B),
      contentTextStyle: const TextStyle(color: Colors.white),
      behavior: SnackBarBehavior.floating,
    ),
    dividerTheme: DividerThemeData(color: scheme.outline.withOpacity(.18)),
  );
}

Color panelColor(BuildContext context) => Theme.of(context).brightness == Brightness.dark
    ? SafeLabPalette.darkPanel : Colors.white;

Color mutedColor(BuildContext context) => Theme.of(context).brightness == Brightness.dark
    ? const Color(0xFFADB8D0) : const Color(0xFF64748B);

LinearGradient safeLabGradient(BuildContext context) => LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: Theme.of(context).brightness == Brightness.dark
      ? [const Color(0xFF17213E), const Color(0xFF16233F), const Color(0xFF103646)]
      : [const Color(0xFFFFFFFF), const Color(0xFFF0F1FF), const Color(0xFFDCF7F4)],
);
