import 'package:circular_check_box/circular_check_box.dart';
import 'package:flutter/material.dart';

class AssignmentListItem extends StatelessWidget {
  final String displayName;
  final bool isAssigned;
  final dynamic onChanged;
  const AssignmentListItem({Key key, this.isAssigned = false, this.onChanged, this.displayName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircularCheckBox(
        value: isAssigned,
        onChanged: (value) { _handleTap(); },
      ),
      title: Text(displayName ?? ''),
    );
  }

  void _handleTap() {
    onChanged(!isAssigned);
  }
}