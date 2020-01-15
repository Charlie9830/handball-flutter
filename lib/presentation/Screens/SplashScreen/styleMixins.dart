import 'package:flutter/material.dart';

final headlineDarkThemeTextStyleMixin = TextStyle(
    color: Color.fromARGB(255, 255, 225, 26),
    fontFamily: 'Ubuntu',
    fontSize: 28,
    fontWeight: FontWeight.w500);

final detailDarkThemeTextStyleMixin = TextStyle(
    color: Color.fromARGB(255, 255, 15, 98),
    fontFamily: 'Ubuntu',
    fontSize: 18);

final headlineLightThemeTextStyleMixin = headlineDarkThemeTextStyleMixin.copyWith(
  color: Color.fromARGB(255, 255, 141, 6),
);

final detailLightThemeTextStyleMixin = detailDarkThemeTextStyleMixin.copyWith(
  color: Color.fromARGB(255, 255, 17, 95)
);

TextStyle getHeadlineTextStyleMixin(Brightness brightness) {
  switch(brightness) {
    case Brightness.dark:
      return headlineDarkThemeTextStyleMixin;

    case Brightness.light:
      return headlineLightThemeTextStyleMixin;

    default:
      return headlineLightThemeTextStyleMixin;
  }
}

TextStyle getDetailTextStyleMixin(Brightness brightness) {
  switch(brightness) {
    case Brightness.dark:
      return detailDarkThemeTextStyleMixin;

    case Brightness.light:
      return detailLightThemeTextStyleMixin;

    default:
      return detailLightThemeTextStyleMixin;
  }
}