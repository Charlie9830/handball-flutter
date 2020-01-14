import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:handball_flutter/enums.dart';

class AppThemeModel {
  int primaryColorIndex;
  int accentColorIndex;
  ThemeBrightness themeBrightness;

  /* 
  Update copyWith Method Below
  */

  AppThemeModel({
    this.primaryColorIndex = 0,
    this.accentColorIndex = 0,
    this.themeBrightness = ThemeBrightness.device,
  });

  AppThemeModel.fromDefault() {
    this.primaryColorIndex = 0;
    this.accentColorIndex = 0;
    this.themeBrightness = ThemeBrightness.device;
  }

  AppThemeModel.fromDocMap(Map<dynamic, dynamic> docMap) {
    this.primaryColorIndex = docMap['primaryColorIndex'] ?? 0;
    this.accentColorIndex = docMap['accentColorIndex'] ?? 0;
    this.themeBrightness = _parseBrightness(docMap['themeBrightness']);
  }
  
  AppThemeModel.fromJSON(String json) {
    final decoder = JsonDecoder();
    final map = decoder.convert(json);

    this.primaryColorIndex = map['primaryColorIndex'] ?? 0;
    this.accentColorIndex = map['accentColorIndex'] ?? 0;
    this.themeBrightness = _parseBrightness(map['themeBrightness']);
  }

  String toJSON() {
    final encoder = JsonEncoder();
    return encoder.convert(toMap());
  }

  Map<dynamic, dynamic> toMap() {
    return {
      'primaryColorIndex': this.primaryColorIndex,
      'accentColorIndex': this.accentColorIndex,
      'themeBrightness': _convertThemeBrightnessToString(this.themeBrightness),
    };
  }

  AppThemeModel copyWith({
    int primaryColorIndex,
    int accentColorIndex,
    ThemeBrightness themeBrightness,
    bool overridePlatformBrightness,
  }) {
    return AppThemeModel(
      primaryColorIndex: primaryColorIndex ?? this.primaryColorIndex,
      accentColorIndex: accentColorIndex ?? this.accentColorIndex,
      themeBrightness: themeBrightness ?? this.themeBrightness,
    );
  }

  String _convertThemeBrightnessToString(ThemeBrightness brightness) {
    switch (brightness) {
      case ThemeBrightness.light:
        return 'light';
      case ThemeBrightness.dark:
        return 'dark';
      case ThemeBrightness.device:
        return 'device';
      default:
        return 'device';
    }
  }

  ThemeBrightness _parseBrightness(String brightness) {
    if (brightness == null || brightness == '') {
      return ThemeBrightness.device;
    }

    if (brightness == 'light') {
      return ThemeBrightness.light;
    } 
    
    if (brightness == 'device') {
      return ThemeBrightness.device;
    }

    if (brightness == 'dark') {
      return ThemeBrightness.dark;
    }

    else {
      return ThemeBrightness.device;
    }
  }

  void debugPrint() {
    print('***App Theme ****');
    print('Brightness: $themeBrightness');
    print('Primary Color Index: $primaryColorIndex');
    print('Accent Color Index: $accentColorIndex');
    print('');
    print('');
  }
}
