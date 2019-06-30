import 'package:flutter/material.dart';
import 'package:handball_flutter/models/AppTheme.dart';
import 'package:handball_flutter/utilities/Colors/AppThemeColors.dart';

ThemeData buildAppThemeData(AppThemeModel appTheme) {
  var defaultTheme = ThemeData();
  if (appTheme == null) {
    return defaultTheme; // Default Theme
  }

  var brightness = appTheme.brightness;

  var unAdjustedPrimaryColor = AppThemeColors.materialColors[appTheme.primaryColorIndex];
  var primaryColor = brightness == Brightness.light ? unAdjustedPrimaryColor.shade200 : unAdjustedPrimaryColor.shade600;
  var primaryColorBrightness = primaryColor.computeLuminance() > 0.5 ? Brightness.light : Brightness.dark;

  var unAdjustedAccentColor =  AppThemeColors.accentColors[appTheme.accentColorIndex];
  var accentColor = brightness == Brightness.light ? unAdjustedAccentColor.shade200 : unAdjustedAccentColor.shade700;
  var accentColorBrightness = accentColor.computeLuminance() > 0.5 ? Brightness.light : Brightness.dark;


  return ThemeData(
    brightness: brightness,
    primaryColor: primaryColor,
    primaryColorBrightness: primaryColorBrightness,
    accentColor: accentColor,
    accentColorBrightness: accentColorBrightness,

  );
}