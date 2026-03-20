import 'package:flutter/material.dart';
import 'package:neural_flow/core/constants/app_colors.dart';

enum AppThemePalette { sky, indigo }

class _ThemeTokens {
  const _ThemeTokens({
    required this.background,
    required this.surface,
    required this.card,
    required this.foreground,
    required this.onSurface,
    required this.primary,
    required this.onPrimary,
    required this.primaryContainer,
    required this.onPrimaryContainer,
    required this.secondary,
    required this.onSecondary,
    required this.mutedForeground,
    required this.border,
    required this.input,
    required this.destructive,
    required this.onDestructive,
  });

  final Color background;
  final Color surface;
  final Color card;
  final Color foreground;
  final Color onSurface;
  final Color primary;
  final Color onPrimary;
  final Color primaryContainer;
  final Color onPrimaryContainer;
  final Color secondary;
  final Color onSecondary;
  final Color mutedForeground;
  final Color border;
  final Color input;
  final Color destructive;
  final Color onDestructive;
}

class AppTheme {
  AppTheme._();

  static const _ThemeTokens _skyLight = _ThemeTokens(
    background: AppColors.lightBackground,
    surface: AppColors.lightSurface,
    card: AppColors.lightCard,
    foreground: AppColors.lightForeground,
    onSurface: AppColors.lightOnSurface,
    primary: AppColors.lightPrimary,
    onPrimary: AppColors.lightPrimaryForeground,
    primaryContainer: AppColors.lightPrimaryContainer,
    onPrimaryContainer: AppColors.lightOnPrimaryContainer,
    secondary: AppColors.lightSecondary,
    onSecondary: AppColors.lightSecondaryForeground,
    mutedForeground: AppColors.lightMutedForeground,
    border: AppColors.lightBorder,
    input: AppColors.lightInput,
    destructive: AppColors.lightDestructive,
    onDestructive: AppColors.lightDestructiveForeground,
  );

  static const _ThemeTokens _skyDark = _ThemeTokens(
    background: AppColors.darkBackground,
    surface: AppColors.darkSurface,
    card: AppColors.darkCard,
    foreground: AppColors.darkForeground,
    onSurface: AppColors.darkOnSurface,
    primary: AppColors.darkPrimary,
    onPrimary: AppColors.darkPrimaryForeground,
    primaryContainer: AppColors.darkPrimaryContainer,
    onPrimaryContainer: AppColors.darkOnPrimaryContainer,
    secondary: AppColors.darkSecondary,
    onSecondary: AppColors.darkSecondaryForeground,
    mutedForeground: AppColors.darkMutedForeground,
    border: AppColors.darkBorder,
    input: AppColors.darkInput,
    destructive: AppColors.darkDestructive,
    onDestructive: AppColors.darkDestructiveForeground,
  );

  // Palette from the OKLCH table shared by the user.
  static const _ThemeTokens _indigoLight = _ThemeTokens(
    background: Color(0xFFFAFBFC),
    surface: Color(0xFFFFFFFF),
    card: Color(0xFFFFFFFF),
    foreground: Color(0xFF1A1F35),
    onSurface: Color(0xFF1A1F35),
    primary: Color(0xFF5947C8),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFF0F0F8),
    onPrimaryContainer: Color(0xFF5B4DB6),
    secondary: Color(0xFFF0F0F8),
    onSecondary: Color(0xFF5B4DB6),
    mutedForeground: Color(0xFF8482BA),
    border: Color(0xFFE4E5ED),
    input: Color(0xFFE4E5ED),
    destructive: Color(0xFFD97706),
    onDestructive: Color(0xFFFAFBFC),
  );

  static const _ThemeTokens _indigoDark = _ThemeTokens(
    background: Color(0xFF1A1F35),
    surface: Color(0xFF252A42),
    card: Color(0xFF252A42),
    foreground: Color(0xFFF0F0F8),
    onSurface: Color(0xFFDBDCE3),
    primary: Color(0xFF7C6FD9),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFF3A3D4F),
    onPrimaryContainer: Color(0xFFDBDCE3),
    secondary: Color(0xFF3A3D4F),
    onSecondary: Color(0xFFDBDCE3),
    mutedForeground: Color(0xFF9A98B0),
    border: Color(0xFF3A3E51),
    input: Color(0xFF3A3E51),
    destructive: Color(0xFFD97706),
    onDestructive: Color(0xFFF0F0F8),
  );

  static _ThemeTokens _tokensFor(
    AppThemePalette palette,
    Brightness brightness,
  ) {
    if (palette == AppThemePalette.indigo) {
      return brightness == Brightness.light ? _indigoLight : _indigoDark;
    }
    return brightness == Brightness.light ? _skyLight : _skyDark;
  }

  static ThemeData lightThemeFor(AppThemePalette palette) {
    return _buildTheme(_tokensFor(palette, Brightness.light), Brightness.light);
  }

  static ThemeData darkThemeFor(AppThemePalette palette) {
    return _buildTheme(_tokensFor(palette, Brightness.dark), Brightness.dark);
  }

  static ThemeData get lightTheme {
    return lightThemeFor(AppThemePalette.sky);
  }

  static ThemeData get darkTheme {
    return darkThemeFor(AppThemePalette.sky);
  }

  static ThemeData _buildTheme(_ThemeTokens tokens, Brightness brightness) {
    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: tokens.primary,
      onPrimary: tokens.onPrimary,
      primaryContainer: tokens.primaryContainer,
      onPrimaryContainer: tokens.onPrimaryContainer,
      secondary: tokens.secondary,
      onSecondary: tokens.onSecondary,
      secondaryContainer: tokens.primaryContainer,
      onSecondaryContainer: tokens.onPrimaryContainer,
      error: tokens.destructive,
      onError: tokens.onDestructive,
      surface: tokens.surface,
      surfaceContainer: tokens.card,
      surfaceContainerHigh: tokens.card,
      surfaceContainerHighest: tokens.card,
      onSurface: tokens.onSurface,
      onSurfaceVariant: tokens.mutedForeground,
      outline: tokens.border,
      outlineVariant: tokens.border,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: tokens.background,
      canvasColor: tokens.background,
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: ZoomPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.macOS: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.fuchsia: FadeUpwardsPageTransitionsBuilder(),
        },
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: tokens.background,
        foregroundColor: tokens.foreground,
        centerTitle: true,
        elevation: 0,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: tokens.background,
        selectedItemColor: tokens.primary,
        // ignore: deprecated_member_use
        unselectedItemColor: tokens.onSurface.withOpacity(0.6),
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: tokens.card,
        elevation: 0,
        margin: EdgeInsets.zero,
      ),
      dividerColor: tokens.border,
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontSize: 108,
          fontWeight: FontWeight.w800,
          letterSpacing: -2.8,
          color: tokens.primary,
          height: 0.95,
        ),
        headlineMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: tokens.foreground,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: tokens.foreground,
        ),
        titleSmall: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          letterSpacing: 2.2,
          color: tokens.mutedForeground,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: tokens.onSurface,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: tokens.mutedForeground,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: tokens.mutedForeground,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: tokens.primary,
          foregroundColor: tokens.onPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: tokens.input,
        hintStyle: TextStyle(color: tokens.mutedForeground),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: tokens.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: tokens.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: tokens.primary, width: 1.4),
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return tokens.primary;
          }
          return tokens.input;
        }),
      ),
    );
  }
}
