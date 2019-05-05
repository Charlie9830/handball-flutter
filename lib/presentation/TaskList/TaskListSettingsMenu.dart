import 'package:flutter/material.dart';

class TaskListSettingsMenu extends StatelessWidget {
  final onSortingChange;
  final onRename;
  final onOpenChecklistSettings;
  final onDelete;
  final onMoveToProject;

  TaskListSettingsMenu({
    Key key,
    this.onSortingChange,
    this.onRename,
    this.onOpenChecklistSettings,
    this.onDelete,
    this.onMoveToProject,
    });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: Icon(Icons.more_vert),
      onSelected: _handleSelection,
      itemBuilder: (BuildContext context) {
        return <PopupMenuEntry<dynamic>>[
          PopupMenuItem(
            child: Text('Sorting', style: Theme.of(context).textTheme.subtitle),
          ),
          PopupMenuDivider(),
          PopupMenuItem(
            child: Text('Completed'),
            value: 'completed',
          ),
          PopupMenuItem(
            child: Text('Priority'),
            value: 'priority',
          ),
          PopupMenuItem(
            child: Text('Due Date'),
            value: 'due date',
          ),
          PopupMenuItem(
            child: Text('Date Added'),
            value: 'date added',
          ),
          PopupMenuItem(
            child: Text('Assignee'),
            value: 'assignee',
          ),
          PopupMenuItem(
            child: Text('Alphabetically'),
            value: 'alphabetically',
          ),
          PopupMenuDivider(),
          PopupMenuItem(
            child: Text('Rename List'),
            value: 'rename list',
          ),
          PopupMenuItem(
            child: Text('Checklist Settings'),
            value: 'checklist settings',
          ),
          PopupMenuItem(
            child: Row(children: <Widget>[Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(Icons.arrow_forward),
            ), 
            Text('Move to project')
            ]),
            value: 'move to project',
          ),
          PopupMenuDivider(),
          PopupMenuItem(
            child: Row(children: <Widget>[Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(Icons.delete),
            ),
            Text('Delete List')]),
            value: 'delete list',
          ),
        ];
      }
    );
  }

  void _handleSelection(value) {
    switch(value) {
      case 'rename list':
      onRename();
      break;

      case 'checklist settings':
      onOpenChecklistSettings();
      break;

      case 'move to project':
      onMoveToProject();
      break;

      case 'delete list':
      onDelete();
      break;

      default:
      // Sorting Options
      onSortingChange(value);
      break;
    }
  }
}