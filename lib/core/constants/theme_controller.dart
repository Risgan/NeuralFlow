import 'package:flutter/material.dart';
import 'package:neural_flow/core/constants/app_theme.dart';

class ThemeController extends ChangeNotifier {
  ThemeController({
    ThemeMode initialThemeMode = ThemeMode.light,
    AppThemePalette initialPalette = AppThemePalette.sky,
  })  : _themeMode = initialThemeMode,
        _palette = initialPalette;

  ThemeMode _themeMode;
  AppThemePalette _palette;

  ThemeMode get themeMode => _themeMode;
  AppThemePalette get palette => _palette;

  void setThemeMode(ThemeMode mode) {
    if (_themeMode == mode) return;
    _themeMode = mode;
    notifyListeners();
  }

  void setPalette(AppThemePalette palette) {
    if (_palette == palette) return;
    _palette = palette;
    notifyListeners();
  }

  void toggleLightDark() {
    _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }
}
