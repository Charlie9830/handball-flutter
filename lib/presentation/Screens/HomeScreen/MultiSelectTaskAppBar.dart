import 'package:flutter/material.dart';

class MultiSelectTaskAppBar extends StatelessWidget {
  final dynamic onCancel;
  final dynamic onMoveTasks;
  const MultiSelectTaskAppBar({Key key, this.onCancel, this.onMoveTasks}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      automaticallyImplyLeading: false,
      leading: IconButton(
        icon: Icon(Icons.close),
        onPressed: onCancel,
      ),
      title: Text('Select Tasks'),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.move_to_inbox),
          onPressed: onMoveTasks,
        )
      ],
    );
  }
}