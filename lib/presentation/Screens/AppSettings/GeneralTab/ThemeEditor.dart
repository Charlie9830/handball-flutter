import 'package:flutter/material.dart';
import 'package:handball_flutter/enums.dart';
import 'package:handball_flutter/models/ThemeEditorViewModel.dart';
import 'package:handball_flutter/presentation/Screens/AppSettings/GeneralTab/MaterialColorPicker.dart';

class ThemeEditor extends StatelessWidget {
  final ThemeEditorViewModel viewModel;
  const ThemeEditor({Key key, this.viewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SwitchListTile(
          secondary: Icon(Icons.brightness_medium),
          title: Text('Dark mode'),
          value: viewModel.data.brightness == Brightness.dark,
          onChanged: (value) => _handleBrightnessSwitchChange(value), 
        ),
        MaterialColorPicker(
          title: 'Primary Color',
          type: MaterialColorPickerType.primary,
          selectedColorIndex: viewModel.data.primaryColorIndex,
          onColorPick: _handleColorPick),
        MaterialColorPicker(
          title: 'Accent Color',
          type: MaterialColorPickerType.accent,
          selectedColorIndex: viewModel.data.accentColorIndex,
          onColorPick: _handleColorPick,
        ),
      ],
    );
  }

  void _handleColorPick(MaterialColorPickerType type, int newIndex) {
    viewModel.onThemeChanged(viewModel.data.copyWith(
      primaryColorIndex: type == MaterialColorPickerType.primary ? newIndex : viewModel.data.primaryColorIndex,
      accentColorIndex: type == MaterialColorPickerType.accent ? newIndex : viewModel.data.accentColorIndex,
    ));
  }

  void _handleBrightnessSwitchChange(bool isDark) {
    viewModel.onThemeChanged(viewModel.data.copyWith(
      brightness: isDark == true ? Brightness.dark : Brightness.light
    ));
  }
}