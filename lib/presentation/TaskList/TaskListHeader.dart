import 'package:flutter/material.dart';
import 'package:handball_flutter/enums.dart';
import 'package:handball_flutter/models/TaskList.dart';
import 'package:handball_flutter/presentation/TaskList/TaskListSettingsMenu.dart';

class TaskListHeader extends StatelessWidget {
  final String name;
  final TaskSorting sorting;
  final bool isChecklist;
  final bool isMenuDisabled;
  final onDelete;
  final onRename;
  final onAddTaskButtonPressed;
  final onSortingChange;
  final onOpenChecklistSettings;
  final dynamic onMoveToProject;

  TaskListHeader({
    Key key,
    this.name,
    this.isMenuDisabled,
    this.isChecklist,
    this.sorting,
    this.onDelete,
    this.onRename,
    this.onAddTaskButtonPressed,
    this.onSortingChange,
    this.onOpenChecklistSettings,
    this.onMoveToProject,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Theme.of(context).colorScheme.secondary;

    return new Container(
      child: Row(
        children: <Widget>[
          TaskListSettingsMenu(
            isDisabled: isMenuDisabled,
            onDelete: onDelete,
            onRename: onRename,
            onSortingChange: onSortingChange,
            onOpenChecklistSettings: onOpenChecklistSettings,
            sorting: sorting,
            onMoveToProject: onMoveToProject,
          ),
          if (isChecklist == true)
            IconButton(
                icon: Icon(Icons.playlist_add_check),
                onPressed: isMenuDisabled == true
                    ? null
                    : () => onOpenChecklistSettings()),
          Expanded(
              child: Text(
            name,
            textAlign: TextAlign.center,
          )),
          IconButton(
            icon: Icon(Icons.add_circle),
            onPressed: onAddTaskButtonPressed,
          )
        ],
      ),
      color: backgroundColor,
    );
  }
}
