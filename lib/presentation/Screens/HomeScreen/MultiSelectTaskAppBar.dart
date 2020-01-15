import 'package:flutter/material.dart';
import 'package:handball_flutter/presentation/Screens/HomeScreen/HomeScreenAppBar.dart';

class MultiSelectTaskAppBar extends StatelessWidget {
  final dynamic onCancel;
  final dynamic onMoveTasks;
  final dynamic onCompleteTasks;
  final dynamic onDeleteTasks;
  final dynamic onAssignTo;

  const MultiSelectTaskAppBar(
      {Key key,
      this.onCancel,
      this.onMoveTasks,
      this.onCompleteTasks,
      this.onDeleteTasks,
      this.onAssignTo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HomeScreenAppBar(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      leading: IconButton(
        icon: Icon(Icons.close),
        onPressed: onCancel,
      ),
      title: 'Select Tasks',
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.move_to_inbox),
          onPressed: onMoveTasks,
        ),
        IconButton(
          icon: Icon(Icons.check_circle),
          onPressed: onCompleteTasks,
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: PopupMenuButton(
            child: Icon(Icons.more_vert),
            itemBuilder: (context) {
              return <PopupMenuItem<dynamic>>[
                // Assign to
                PopupMenuItem(
                    value: 'assign-to',
                    child: ListTile(
                      leading: Icon(Icons.person),
                      title: Text('Assign to'),
                    )),

                // Delete Tasks
                PopupMenuItem(
                  enabled: onDeleteTasks != null,
                  value: 'delete-tasks',
                  child: ListTile(
                    leading: Icon(Icons.delete_sweep),
                    title: Text('Delete selected'),
                  ),
                ),
              ];
            },
            onSelected: (value) {
              if (value == 'assign-to') {
                onAssignTo();
              }

              if (value == 'delete-tasks') {
                onDeleteTasks();
              }
            }
          ),
        ),
      ],
    );
  }
}
