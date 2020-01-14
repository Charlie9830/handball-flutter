import 'package:flutter/material.dart';
import 'package:handball_flutter/enums.dart';
import 'package:handball_flutter/presentation/Screens/AppSettings/GeneralTab/BrightnessSelectorOption.dart';

class BrightnessSelector extends StatelessWidget {
  final ThemeBrightness themeBrightness;
  final dynamic onChange;
  const BrightnessSelector({Key key, this.themeBrightness, this.onChange}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final groupValue = themeBrightness;
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        BrightnessSelectorOption(
          label: 'Light',
          value: ThemeBrightness.light,
          groupValue: groupValue,
          onSelected: () => onChange(ThemeBrightness.light),
        ),
        BrightnessSelectorOption(
          label: 'Dark',
          value: ThemeBrightness.dark,
          groupValue: groupValue,
          onSelected: () => onChange(ThemeBrightness.dark)
        ),
        BrightnessSelectorOption(
          label: 'Follow device settings',
          value: ThemeBrightness.device,
          groupValue: groupValue,
          onSelected: () => onChange(ThemeBrightness.device)
        )
      ],
    );
  }
}
