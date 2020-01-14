import 'package:flutter/material.dart';
import 'package:handball_flutter/enums.dart';
import 'package:handball_flutter/models/AppTheme.dart';
import 'package:handball_flutter/models/ThemeDataTuple.dart';
import 'package:handball_flutter/utilities/Colors/AppThemeColors.dart';

ThemeDataTuple buildAppThemeData(AppThemeModel appTheme) {
  var defaultTheme = ThemeData();
  if (appTheme == null) {
    return ThemeDataTuple(
        dark: defaultTheme, light: defaultTheme); // Default Theme
  }

  var primaryColor = AppThemeColors.materialColors[appTheme.primaryColorIndex];

  var accentColor = AppThemeColors.accentColors[appTheme.accentColorIndex];

  // final colorScheme = brightness == Brightness.dark
  //     ? ColorScheme.dark(
  //         primary: primaryColor, secondary: accentColor)
  //     : ColorScheme.light(
  //         primary: primaryColor, secondary: accentColor);

  return ThemeDataTuple(
    // Dark
    dark: ThemeData(
      primaryColor: primaryColor,
      accentColor: accentColor,
      brightness: Brightness.dark,
      fontFamily: 'Archivo',
    ),

    // Light
    light: ThemeData(
      primaryColor: primaryColor,
      accentColor: accentColor,
      brightness: Brightness.light,
      fontFamily: 'Archivo',
    ),
  );
}

Brightness _downcastThemeBrightness(ThemeBrightness themeBrightness) {
  if (themeBrightness == ThemeBrightness.dark) {
    return Brightness.dark;
  }

  if (themeBrightness == ThemeBrightness.light) {
    return Brightness.light;
  } else {
    return null;
  }
}
