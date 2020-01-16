import 'package:flutter/material.dart';
import 'package:handball_flutter/enums.dart';
import 'package:handball_flutter/models/AppTheme.dart';
import 'package:handball_flutter/models/ThemeDataTuple.dart';
import 'package:handball_flutter/utilities/Colors/AppThemeColors.dart';

ThemeDataTuple buildAppThemeData(AppThemeModel appTheme) {
  final defaultTheme = ThemeData();
  if (appTheme == null) {
    return ThemeDataTuple(
        dark: defaultTheme, light: defaultTheme); // Default Theme
  }

  final primaryColor = AppThemeColors.materialColors[appTheme.primaryColorIndex];
  final accentColor = AppThemeColors.accentColors[appTheme.accentColorIndex];

  // final colorScheme = brightness == Brightness.dark
  //     ? ColorScheme.dark(
  //         primary: primaryColor, secondary: accentColor)
  //     : ColorScheme.light(
  //         primary: primaryColor, secondary: accentColor);
  
  // baseDarkTheme and baseLightTheme are used to inform the Child Themes, eg: ButtonTheme, PopupMenuTheme.
  final baseDarkTheme = ThemeData(
    primaryColor: primaryColor,
    accentColor: accentColor,
    brightness: Brightness.dark,
  );

  final baseLightTheme = ThemeData(
    primaryColor: primaryColor,
    accentColor: accentColor,
    brightness: Brightness.light,
  );

  final buttonShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(8)
  );

  final buttonDarkTheme = baseDarkTheme.buttonTheme.copyWith(
    colorScheme: baseDarkTheme.colorScheme,
    shape: buttonShape
  );

  final buttonLightTheme = baseLightTheme.buttonTheme.copyWith(
    colorScheme: baseLightTheme.colorScheme,
    shape: buttonShape,
  );

  final popupMenuDarkTheme = PopupMenuThemeData(
    color: baseDarkTheme.popupMenuTheme.color,
    elevation: baseDarkTheme.popupMenuTheme.elevation,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  );

  final popupMenuLightTheme = PopupMenuThemeData(
    color: baseLightTheme.popupMenuTheme.color,
    elevation: baseLightTheme.popupMenuTheme.elevation,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  );

  

  return ThemeDataTuple(
    // Dark
    dark: ThemeData(
      primaryColor: primaryColor,
      accentColor: accentColor,
      brightness: Brightness.dark,
      fontFamily: 'Archivo',
      buttonTheme: buttonDarkTheme,
      popupMenuTheme: popupMenuDarkTheme,
      
    ),

    // Light
    light: ThemeData(
      primaryColor: primaryColor,
      accentColor: accentColor,
      brightness: Brightness.light,
      fontFamily: 'Archivo',
      buttonTheme: buttonLightTheme,
      popupMenuTheme: popupMenuLightTheme,
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
