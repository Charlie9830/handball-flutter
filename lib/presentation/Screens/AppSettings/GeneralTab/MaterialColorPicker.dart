import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:handball_flutter/enums.dart';
import 'package:handball_flutter/presentation/Screens/AppSettings/GeneralTab/ColorChit.dart';
import 'package:handball_flutter/utilities/Colors/AppThemeColors.dart';

class MaterialColorPicker extends StatelessWidget {
  final String title;
  final int selectedColorIndex;
  final MaterialColorPickerType type;
  final dynamic onColorPick;

  const MaterialColorPicker(
      {Key key,
      this.selectedColorIndex,
      this.title,
      @required this.type,
      this.onColorPick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(title ?? ''),
        Wrap(
          alignment: WrapAlignment.start,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 0,
          runSpacing: 0,
          children: _getChildren(),
        ),
      ],
    );
  }

  List<Widget> _getChildren() {
    var colors = type == MaterialColorPickerType.primary
        ? AppThemeColors.materialColors
        : AppThemeColors.accentColors;

    var widgets = <Widget>[];

    for (int i = 0; i < colors.length; i++) {
      widgets.add(ColorChit(
          color: colors[i],
          isSelected: i == selectedColorIndex,
          onPressed: () => onColorPick(type, i)));
    }

    return widgets;
  }
}
