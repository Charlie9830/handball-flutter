import 'package:flutter/material.dart';

class BrightnessSelectorOption extends StatelessWidget {
  final Object groupValue;
  final Object value;
  final String label;
  final dynamic onSelected;
  const BrightnessSelectorOption(
      {Key key, this.value, this.label, this.onSelected, this.groupValue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Radio(
            value: value,
            groupValue: groupValue,
            onChanged: (value) {
              onSelected();
            }),
        Text(label ?? ''),
      ],
    );
  }
}
