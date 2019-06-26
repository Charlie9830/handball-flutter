import 'package:flutter/material.dart';
import 'package:handball_flutter/presentation/Task/SelectCheckbox.dart';
import 'package:circular_check_box/circular_check_box.dart';

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
    return AnimatedCrossFade(
        firstChild: Checkbox(value: isComplete, onChanged: onCheckboxChanged),
        secondChild: CircularCheckBox(value: isSelected, onChanged: onRadioChanged),
        crossFadeState: isInMultiSelectTaskMode ? CrossFadeState.showSecond : CrossFadeState.showFirst,
        duration: Duration(milliseconds: 250),
        );
        
  }
}
