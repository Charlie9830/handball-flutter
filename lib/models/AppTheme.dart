import 'dart:convert';

import 'package:flutter/material.dart';

class AppThemeModel {
  int primaryColorIndex;
  int accentColorIndex;
  Brightness brightness;

  /* 
  Update copyWith Method Below
  */

  AppThemeModel({
    this.primaryColorIndex = 0,
    this.accentColorIndex = 0,
    this.brightness = Brightness.light,
  });

  AppThemeModel.fromDefault() {
    this.primaryColorIndex = 0;
    this.accentColorIndex = 0;
    this.brightness = Brightness.light;
  }

  AppThemeModel.fromDocMap(Map<dynamic, dynamic> docMap) {
    this.primaryColorIndex = docMap['primaryColorIndex'] ?? 0;
    this.accentColorIndex = docMap['accentColorIndex'] ?? 0;
    this.brightness = _parseBrightness(docMap['brightness']);
  }
  
  AppThemeModel.fromJSON(String json) {
    final decoder = JsonDecoder();
    final map = decoder.convert(json);

    this.primaryColorIndex = map['primaryColorIndex'] ?? 0;
    this.accentColorIndex = map['accentColorIndex'] ?? 0;
    this.brightness = _parseBrightness(map['brightness']);
  }

  String toJSON() {
    final encoder = JsonEncoder();
    return encoder.convert(toMap());
  }

  Map<dynamic, dynamic> toMap() {
    return {
      'primaryColorIndex': this.primaryColorIndex,
      'accentColorIndex': this.accentColorIndex,
      'brightness': _convertBrightnessToString(this.brightness),
    };
  }

  AppThemeModel copyWith({
    int primaryColorIndex,
    int accentColorIndex,
    Brightness brightness,
  }) {
    return AppThemeModel(
      primaryColorIndex: primaryColorIndex ?? this.primaryColorIndex,
      accentColorIndex: accentColorIndex ?? this.accentColorIndex,
      brightness: brightness ?? this.brightness,
    );
  }

  String _convertBrightnessToString(Brightness brightness) {
    switch (brightness) {
      case Brightness.dark:
        return 'dark';
      case Brightness.light:
        return 'light';
      default:
        return 'light';
    }
  }

  Brightness _parseBrightness(String brightness) {
    if (brightness == null || brightness == '') {
      return Brightness.light;
    }

    if (brightness == 'light') {
      return Brightness.light;
    } else {
      return Brightness.dark;
    }
  }

  void debugPrint() {
    print('***App Theme ****');
    print('Brightness: $brightness');
    print('Primary Color Index: $primaryColorIndex');
    print('Accent Color Index: $accentColorIndex');
    print('');
    print('');
  }
}
