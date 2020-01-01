import 'package:circular_check_box/circular_check_box.dart';
import 'package:flutter/material.dart';

class TaskCheckbox extends StatelessWidget {
  final bool isInMultiSelectTaskMode;
  final bool isComplete;
  final bool isSelected;
  final dynamic onRadioChanged;
  final dynamic onCheckboxChanged;
  const TaskCheckbox(
      {Key key,
      this.isComplete,
      this.onCheckboxChanged,
      this.isInMultiSelectTaskMode,
      this.isSelected,
      this.onRadioChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final circularCheckboxInactiveColor = Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black;

    return AnimatedCrossFade(
        firstChild: Checkbox(value: isComplete, onChanged: onCheckboxChanged),
        secondChild: CircularCheckBox(value: isSelected, onChanged: onRadioChanged, inactiveColor: circularCheckboxInactiveColor, ),
        crossFadeState: isInMultiSelectTaskMode ? CrossFadeState.showSecond : CrossFadeState.showFirst,
        duration: Duration(milliseconds: 250),
        );
  }
}
