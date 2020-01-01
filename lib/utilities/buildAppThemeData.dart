import 'package:flutter/material.dart';
import 'package:handball_flutter/models/AppTheme.dart';
import 'package:handball_flutter/utilities/Colors/AppThemeColors.dart';

ThemeData buildAppThemeData(AppThemeModel appTheme) {
  var defaultTheme = ThemeData();
  if (appTheme == null) {
    return defaultTheme; // Default Theme
  }

  var brightness = appTheme.brightness;

  var primaryColor =
      AppThemeColors.materialColors[appTheme.primaryColorIndex];

  var accentColor =
      AppThemeColors.accentColors[appTheme.accentColorIndex];

  // final colorScheme = brightness == Brightness.dark
  //     ? ColorScheme.dark(
  //         primary: primaryColor, secondary: accentColor)
  //     : ColorScheme.light(
  //         primary: primaryColor, secondary: accentColor);

  return ThemeData(
    primaryColor: primaryColor,
    accentColor: accentColor,
    brightness: brightness,
    //colorScheme: colorScheme,
    fontFamily: 'Archivo',
  );
}
