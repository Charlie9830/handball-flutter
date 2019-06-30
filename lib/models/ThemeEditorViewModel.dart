import 'package:handball_flutter/models/AppTheme.dart';

class ThemeEditorViewModel {
  final AppThemeModel data;
  bool isEnabled;
  final dynamic onThemeChanged;

  ThemeEditorViewModel({
    this.data,
    this.isEnabled,
    this.onThemeChanged,
  });
}